//
//  NFGoogleMapsIntegration.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 02/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFGoogleMapsIntegration.h"

static NSString * const kURLScheme = @"comgooglemaps://";
static NSString * const kURLFormat = @"%@?daddr=%@";

@implementation NFGoogleMapsIntegration

+ (BOOL)canOpenDirectionsInGoogleMaps
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kURLScheme]];
}

+ (void)openDirectionsInGoogleMapsWithIgreja:(NFIgreja *)igreja
{
    NSString *endereco = igreja.endereco;
    if (igreja.bairro) {
        endereco = [endereco stringByAppendingFormat:@", %@", igreja.bairro];
    }
    if (igreja.cep) {
        endereco = [endereco stringByAppendingFormat:@" - CEP %@", igreja.cep];
    }
    endereco = [endereco stringByAppendingFormat:@", Rio de Janeiro - RJ"];
    endereco = [endereco stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *url = [NSString stringWithFormat:kURLFormat, kURLScheme, endereco];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
