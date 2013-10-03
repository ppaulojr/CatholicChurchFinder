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
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet NFIgrejaEventsPanel *missaEventsPanel;
@property (weak, nonatomic) IBOutlet NFIgrejaEventsPanel *confissaoEventsPanel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *missaEventsPanelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confissaoEventsPanelHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *observacaoTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *observacaoTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *lastView;

@property (strong, nonatomic) NSMutableArray *phoneTextCheckingResults;

@end

@implementation NFIgrejaDetailPanel

+ (instancetype)panel
{
    return [[NSBundle mainBundle] loadNibNamed:@"NFIgrejaDetailPanel" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    // This removes the margins in the text view
    if ([self.observacaoTextView respondsToSelector:@selector(textContainer)])
    {
        self.observacaoTextView.textContainerInset = UIEdgeInsetsZero;
        self.observacaoTextView.textContainer.lineFragmentPadding = 0.0f;
    } else {
        self.observacaoTextView.contentInset = UIEdgeInsetsMake(-8, -8, -8, -8);
    }
    
}

- (void)_setTextOrNil:(NSString *)textOrNil forLabel:(id)label
{
    if (textOrNil) {
        [label setText:textOrNil];
    } else {
        NSDictionary *attrs = @{
            NSFontAttributeName : [UIFont italicSystemFontOfSize:14],
            NSForegroundColorAttributeName : [UIColor grayColor]
        };
        [label setAttributedText:[[NSAttributedString alloc] initWithString:@"(Not available)" attributes:attrs]];
    }
}

- (NSDictionary *)_attributesForLink
{
    return @{
        NSForegroundColorAttributeName : [UIColor blueColor]
    };
}

- (void)_reset
{
    for (UIView *view in @[self.telefonesLabel, self.siteLabel]) {
        for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
            [view removeGestureRecognizer:recognizer];
        }
    }
    self.phoneTextCheckingResults = nil;
}

- (void)configureWithIgreja:(NFIgreja *)igreja
{
    // Reset in case we are being reconfigured
    [self _reset];

    self.nomeLabel.text = [igreja.nome uppercaseString];
    NSString * obs = nil;
    if (igreja.secretaria) {
        if (igreja.observacao) {
            obs = [NSString stringWithFormat:@"Office Hours:\n%@\n%@",igreja.secretaria,igreja.observacao];
        } else {
            obs = [NSString stringWithFormat:@"Office Hours:\n%@",igreja.secretaria];
        }
    } else {
        obs = igreja.observacao;
    }
    
    [self _setTextOrNil:igreja.paroco forLabel:self.parocoLabel];
    [self _setTextOrNil:igreja.telefones forLabel:self.telefonesLabel];
    [self _setTextOrNil:igreja.site forLabel:self.siteLabel];
    [self _setTextOrNil:obs forLabel:self.observacaoTextView];

    // Compose the address
    NSMutableString *endereco = [igreja.endereco mutableCopy];
    if (igreja.bairro) {
        [endereco appendFormat:@"\n%@", igreja.bairro];
    }
    if (igreja.cep) {
        [endereco appendFormat:@"\nZIP %@", igreja.cep];
    }

    // Create a link to the address in maps
    self.enderecoLabel.attributedText = [[NSAttributedString alloc] initWithString:endereco attributes:[self _attributesForLink]];

    // Add the gesture recognizer to the address label
    id recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_addressLinkTapped)];
    [self.enderecoLabel addGestureRecognizer:recognizer];
    self.enderecoLabel.userInteractionEnabled = YES;

    // If we can detect phone numbers, make them look like links
    // and add a gesture recognizer to the label
    if (igreja.telefones && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:igreja.telefones];
        NSDictionary *attrs = [self _attributesForLink];

        // We need the cast because NSTextCheckingTypes and NSTextCheckingType are
        // two different enums these days. An API bug, bug this is 100% safe and
        // it's documented (although the docs don't mention the cast)
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypePhoneNumber error:NULL];

        [detector enumerateMatchesInString:igreja.telefones options:kNilOptions range:NSMakeRange(0, igreja.telefones.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            // Save the result for later
            if (!self.phoneTextCheckingResults) {
                self.phoneTextCheckingResults = [NSMutableArray arrayWithCapacity:10];
            }
            [self.phoneTextCheckingResults addObject:result];

            // Add the link style
            [attrStr addAttributes:attrs range:result.range];
        }];

        if (self.phoneTextCheckingResults) {
            // Set up the label to use the attributed string
            self.telefonesLabel.attributedText = attrStr;

            // Add a gesture recognizer to open the phone numbers
            id recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_phoneLinkTapped)];
            [self.telefonesLabel addGestureRecognizer:recognizer];
            self.telefonesLabel.userInteractionEnabled = YES;
        }
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
            NSDictionary *attrs = [self _attributesForLink];
            self.siteLabel.attributedText = [[NSAttributedString alloc] initWithString:siteStr attributes:attrs];

            // Add a gesture recognizer to open the link
            id recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_siteLinkTapped)];
            [self.siteLabel addGestureRecognizer:recognizer];
            self.siteLabel.userInteractionEnabled = YES;
        }
    }
    
    if (igreja.email) {
        // Add a gesture recognizer to open the link
        NSDictionary *attrs = [self _attributesForLink];
        self.emailLabel.attributedText = [[NSAttributedString alloc] initWithString:igreja.email attributes:attrs];
        id recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_emailLinkTapped)];
        [self.emailLabel addGestureRecognizer:recognizer];
        self.emailLabel.userInteractionEnabled = YES;
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

    size = [self.observacaoTextView sizeThatFits:self.bounds.size];
    self.observacaoTextViewHeightConstraint.constant = size.height;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [self layoutIfNeeded];

    size.height = CGRectGetMaxY(self.lastView.frame) + 20;
    return size;
}

- (void)_addressLinkTapped
{
    [self.delegate igrejaDetailPanelAddressLinkTapped:self];
}

- (void)_phoneLinkTapped
{
    [self.delegate igrejaDetailPanel:self phoneLinkTappedWithTextCheckingResults:self.phoneTextCheckingResults];
}

- (void)_siteLinkTapped
{
    [self.delegate igrejaDetailPanelSiteLinkTapped:self];
}

- (void) _emailLinkTapped
{
    [self.delegate igrejaDetailPanelEmailLinkTapped:self emailTapped:self.emailLabel.text];
}

@end
