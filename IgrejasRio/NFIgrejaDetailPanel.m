//
//  NFIgrejaDetailPanel.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 26/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFEvent.h"
#import "NFIgrejaDetailPanel.h"
#import "NFIgrejaEventsPanel.h"

@interface NFIgrejaDetailPanel ()

@property (weak, nonatomic) IBOutlet UILabel *nomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *enderecoLabel;
@property (weak, nonatomic) IBOutlet UILabel *parocoLabel;
@property (weak, nonatomic) IBOutlet UILabel *telefonesLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet NFIgrejaEventsPanel *missaEventsPanel;
@property (weak, nonatomic) IBOutlet NFIgrejaEventsPanel *confissaoEventsPanel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *missaEventsPanelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confissaoEventsPanelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *lastView;

@end

@implementation NFIgrejaDetailPanel

+ (instancetype)panel
{
    return [[NSBundle mainBundle] loadNibNamed:@"NFIgrejaDetailPanel" owner:nil options:nil][0];
}

- (void)_setTextOrNil:(NSString *)textOrNil forLabel:(UILabel *)label
{
    if (textOrNil) {
        label.text = textOrNil;
    } else {
        NSDictionary *attrs = @{
            NSFontAttributeName : [UIFont italicSystemFontOfSize:14],
            NSForegroundColorAttributeName : [UIColor grayColor]
        };
        label.attributedText = [[NSAttributedString alloc] initWithString:@"(Não informado)" attributes:attrs];
    }
}

- (void)configureWithIgreja:(NFIgreja *)igreja
{
    self.nomeLabel.text = igreja.nome;
    [self _setTextOrNil:igreja.paroco forLabel:self.parocoLabel];
    [self _setTextOrNil:igreja.telefones forLabel:self.telefonesLabel];
    [self _setTextOrNil:igreja.site forLabel:self.siteLabel];

    // Compose the address
    NSMutableString *endereco = [igreja.endereco mutableCopy];
    if (igreja.bairro) {
        [endereco appendFormat:@"\n%@", igreja.bairro];
    }
    if (igreja.cep) {
        [endereco appendFormat:@"\nCEP %@", igreja.cep];
    }
    self.enderecoLabel.text = endereco;

    // Make sure we don't have recognizers attached (in case we're reconfigured)
    if (self.siteLabel.gestureRecognizers.count) {
        [self.siteLabel removeGestureRecognizer:self.siteLabel.gestureRecognizers[0]];
    }

    // If we do have a site, make it look like a link
    // and add a gesture recognizer to it
    if (igreja.site) {
        // Make sure it has a scheme (this is a common mistake)
        NSString *siteStr = igreja.site;
        if (![siteStr hasPrefix:@"http://"] && ![siteStr hasPrefix:@"https://"]) {
            siteStr = [@"http://" stringByAppendingString:siteStr];
        }

        // Get an URL from it
        NSURL *siteURL = [[NSURL URLWithString:siteStr] standardizedURL];
        if (siteURL) {
            // Get the normalized URL and strip the scheme
            siteStr = [[siteURL absoluteString] substringFromIndex:[siteURL scheme].length + 3];

            // If it's just the host name and a slash, strip the slash
            if ([siteStr hasSuffix:@"/"] && siteStr.length == [siteURL host].length + 1) {
                siteStr = [siteURL host];
            }

            // Make it look like a link
            NSDictionary *attrs = @{
                NSForegroundColorAttributeName : [UIColor blueColor],
                NSUnderlineStyleAttributeName : @YES
            };
            self.siteLabel.attributedText = [[NSAttributedString alloc] initWithString:siteStr attributes:attrs];

            // Add a gesture recognizer to open the link
            id recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_siteLinkTapped)];
            [self.siteLabel addGestureRecognizer:recognizer];
            self.siteLabel.userInteractionEnabled = YES;
        }
    }

    NSPredicate *missaPredicate = [NSPredicate predicateWithFormat:@"self.type == %@", @(NFEventTypeMissa)];
    [self.missaEventsPanel configureWithEvents:[igreja.eventSet filteredSetUsingPredicate:missaPredicate]];

    NSPredicate *confissaoPredicate = [NSPredicate predicateWithFormat:@"self.type == %@", @(NFEventTypeConfissao)];
    [self.confissaoEventsPanel configureWithEvents:[igreja.eventSet filteredSetUsingPredicate:confissaoPredicate]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // We need to update the constraints to take into
    // acount the new frame for the events panels
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [super updateConstraints];

    CGSize size = [self.missaEventsPanel sizeThatFits:self.bounds.size];
    self.missaEventsPanelHeightConstraint.constant = size.height;

    size = [self.confissaoEventsPanel sizeThatFits:self.bounds.size];
    self.confissaoEventsPanelHeightConstraint.constant = size.height;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [self layoutIfNeeded];

    size.height = CGRectGetMaxY(self.lastView.frame) + 20;
    return size;
}

- (void)_siteLinkTapped
{
    [self.delegate igrejaDetailPanelSiteLinkTapped:self];
}

@end
