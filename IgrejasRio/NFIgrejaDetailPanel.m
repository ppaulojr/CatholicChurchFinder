//
//  NFIgrejaDetailPanel.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 26/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFIgrejaDetailPanel.h"

@interface NFIgrejaDetailPanel ()

@property (weak, nonatomic) IBOutlet UILabel *nomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *enderecoLabel;
@property (weak, nonatomic) IBOutlet UILabel *parocoLabel;
@property (weak, nonatomic) IBOutlet UILabel *telefonesLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
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

    NSMutableString *endereco = [igreja.endereco mutableCopy];
    if (igreja.bairro) {
        [endereco appendFormat:@"\n%@", igreja.bairro];
    }
    if (igreja.cep) {
        [endereco appendFormat:@"\nCEP %@", igreja.cep];
    }
    self.enderecoLabel.text = endereco;

    [self setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [self layoutIfNeeded];

    size.height = CGRectGetMaxY(self.lastView.frame) + 20;
    return size;
}

@end
