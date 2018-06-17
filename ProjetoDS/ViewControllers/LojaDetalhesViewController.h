//
//  LojaDetalhesViewController.h
//  ProjetoDS
//
//  Created by Davison Dantas on 29/12/2017.
//  Copyright © 2017 Davison. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LojaDetalhesViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property NSString *nomeLojaDetalhes;
@property NSString *idLojaDetalhes;
@property NSString *enderecoLojaDetalhes;
@property NSString *telefoneLojaDetalhes;
@property UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIView *frameForCapture;
@property (strong, nonatomic) NSMutableArray *mutableArray;
@end
