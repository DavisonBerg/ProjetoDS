//
//  LojaEndereco.h
//  ProjetoDS
//
//  Created by Davison Dantas on 29/12/2017.
//  Copyright © 2017 Davison. All rights reserved.
//

#import <Foundation/Foundation.h>

//Classe que modela os dado contidos em um endereço da loja
@interface LojaEndereco : NSObject
    @property(nonatomic,copy)NSString *logradouro;
    @property(nonatomic,copy)NSString *complemento;
    @property(nonatomic,copy)NSString *bairro;
    @property(nonatomic,strong)NSNumber *numero;
@end
