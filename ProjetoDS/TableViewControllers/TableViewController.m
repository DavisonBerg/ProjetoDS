//
//  TableViewController.m
//  ProjetoDS
//
//  Created by Davison Dantas on 29/12/2017.
//  Copyright © 2017 Davison. All rights reserved.
//

#import "TableViewController.h"
#import "LojaDetalhesViewController.h"
#import "LojaCelula.h"
#import "LojaEndereco.h"
#import "AppDelegate.h"

@interface TableViewController (){
    NSString *nome;
    NSMutableArray *listaAux;
}
    @property (strong, nonatomic) IBOutlet UITableView *tableView;
  
@end

@implementation TableViewController

 
    
- (void) recuperarJson{
    //Fazendo requisição
    NSURL *url = [NSURL URLWithString:@"https://api.myjson.com/bins/hvcbf"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    NSDictionary *jsonRecuperado = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error: &error];
    
    
    if(error == nil){
        NSDictionary *dict = [jsonRecuperado objectForKey: @"lojas"];
        for(NSDictionary *objetos in dict){
            LojaCelula *loja = [[LojaCelula alloc] init];
            loja.objID = objetos[@"id"];
            loja.nome = objetos[@"nome"];
            loja.telefone = objetos[@"telefone"];
     
            
            loja.endereco = [[LojaEndereco alloc] init];
            NSDictionary *objetoEndereco = objetos[@"endereco"];
            loja.endereco.bairro = objetoEndereco[@"bairro"];
            loja.endereco.complemento = objetoEndereco[@"complemento"];
            loja.endereco.logradouro = objetoEndereco[@"logradouro"];
            loja.endereco.numero = objetoEndereco[@"numero"];
            
            [listaAux addObject:loja];
            
        }
    }else{
        NSLog(@"Ocorreu um erro");
    }
    
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.dataSource = self;
    self.tableView.delegate  = self;
    listaAux = [[NSMutableArray alloc] init];
   
    [self recuperarJson];
  
}

    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return listaAux.count;
}


//Carregando os dados na célula da tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
     LojaCelula* p = listaAux[indexPath.row];
     cell.textLabel.text = p.nome;
     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",p.objID];
     NSLog(@"%@",p.nome);
    

    return cell;
   
}

//Enviando os dados para a segunda tela
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier  isEqual: @"detalheLoja"]){
        NSString *endereco;
        NSString *numero;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        if(indexPath){
            LojaCelula* p = listaAux[indexPath.row];
            LojaDetalhesViewController *viewController = segue.destinationViewController;
            viewController.nomeLojaDetalhes = p.nome;
            viewController.idLojaDetalhes = [NSString stringWithFormat:@"%@",p.objID];
            viewController.telefoneLojaDetalhes = p.telefone;
            

            //Transformando o numero do endereço em uma string
            numero = [ NSString stringWithFormat:@"%@",p.endereco.numero];
            //Concatenando os detalhes do endereço da loja em uma única string
            endereco = [ NSString stringWithFormat:@"%@, Numero: %@, Complemento: %@, Bairro: %@", p.endereco.logradouro, numero, p.endereco.complemento, p.endereco.bairro];
            viewController.enderecoLojaDetalhes = endereco;
            
           
        }
        
    }
}

@end
