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

- (void)configureWithIgreja:(NFIgreja *)igreja
{
    self.nomeLabel.text = igreja.nome;
    self.parocoLabel.text = igreja.paroco;
    self.telefonesLabel.text = igreja.telefones;
    self.siteLabel.text = igreja.site;

    NSMutableString *endereco = [igreja.endereco mutableCopy];
    if (igreja.bairro) {
        [endereco appendFormat:@"\n%@", igreja.bairro];
    }
    if (igreja.cep) {
        [endereco appendFormat:@"\nCEP %@", igreja.cep];
    }
    self.enderecoLabel.text = endereco;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [self updateConstraintsIfNeeded];

    size.height = CGRectGetMaxY(self.lastView.frame) + 20;
    return size;
}

@end
