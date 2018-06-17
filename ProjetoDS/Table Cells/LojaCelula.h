//
//  LojaCelula.h
//  ProjetoDS
//
//  Created by Davison Dantas on 29/12/2017.
//  Copyright © 2017 Davison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LojaEndereco.h"

//Classe que modela os dados da célula da tableView
@interface LojaCelula : NSObject
    
    @property(nonatomic,strong)NSNumber *objID;
    @property(nonatomic,copy)NSString *nome;
    @property(nonatomic,copy)NSString *telefone;
    @property(nonatomic,strong)LojaEndereco *endereco;
    
@end
