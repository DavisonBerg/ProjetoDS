//
//  LojaDetalhesViewController.m
//  ProjetoDS
//
//  Created by Davison Dantas on 29/12/2017.
//  Copyright © 2017 Davison. All rights reserved.
//

#import "LojaDetalhesViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>


@interface LojaDetalhesViewController (){
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
}

@property (weak, nonatomic) IBOutlet UILabel *nomeLabel;
    @property (weak, nonatomic) IBOutlet UILabel *idLabel;
    @property (weak, nonatomic) IBOutlet UILabel *enderecoLabel;
    @property (weak, nonatomic) IBOutlet UILabel *telefoneLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *lojaImage;
    
    @property (strong, nonatomic) NSMutableArray *data;
    
@end

@implementation LojaDetalhesViewController
 
@synthesize mutableArray;
AVCaptureSession *session;
AVCaptureStillImageOutput *capturePhotoOutput;


//Criando uma câmera
- (void)viewWillAppear:(BOOL)animated{
    
    //
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];

    
    //Câmera do dispositivo, o dispositivo padrão pode gravar videos
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    //A câmera do dispositivo reconhece a câmera criada
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error: &error];
    
    if([session canAddInput:deviceInput]){
        [session addInput:deviceInput];
    }
    
    //Criando um preview da câmera, que pode ser visto na viewController e preenche toda a view frameForCapture
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.frameForCapture.frame;
    [previewLayer setFrame: frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    //A foto captura será a imagem que está aparecendo na view (no preview)
    capturePhotoOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [capturePhotoOutput setOutputSettings:outputSettings];
    
    [session addOutput:capturePhotoOutput];
    
    //Começa a mostrar o preview
    [session startRunning];
    
}


- (IBAction)tirarFoto:(id)sender {
    
    //Criado um Alerta para o usuário escolher entre tirar foto e carregar imagem da galeria de fotos
    UIAlertController *alerta = [UIAlertController alertControllerWithTitle:@"Capturar Foto" message:@"Deseja adicionar uma foto?" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Tirar foto" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self tirarFoto];
    }];
    
    UIAlertAction *rolo = [UIAlertAction actionWithTitle:@"Rolo da Câmera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self carregarFoto];
    }];
    UIAlertAction *cancelar = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
    
    [alerta addAction:camera];
    [alerta addAction:rolo];
    [alerta addAction:cancelar];
    
    [self presentViewController:alerta animated:YES completion:nil];
    
}

//Tira uma foto ao clicar na view que tem a câmera
- (void)tirarFoto{
    
    AVCaptureConnection *videoConnection = nil;
    
    //Quando o botão (que está dentro da view) é clicado uma  foto é tirada
    for(AVCaptureConnection *connection in capturePhotoOutput.connections){
        for(AVCaptureInputPort *port in [connection inputPorts]){
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    //Capturando a imagem que está aparecendo na view, a saída é um NSData, e é transformado pra uma UIImage. Captura a imagem de modo assíncrono, o preview não é parado para poder tirar a foto
    [capturePhotoOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            self.lojaImage.image = image;
        }
    }];
}

//Carrega foto da galeria de fotos
- (void)carregarFoto{
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
}

//Escolhendo foto da biblioteca de fotos e inserindo na imageView
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    picker.delegate = self;
    UIImage *imagePicked = info[UIImagePickerControllerEditedImage];

    
    //Passa a imagem para imageView
    _lojaImage.image = imagePicked;
    [self.imagePicker dismissViewControllerAnimated:true completion:nil];
    
}
- (IBAction)salvarDados:(id)sender {
    
    //Salva imagem na Biblioteca de Fotos do Dispositivo
    UIImageWriteToSavedPhotosAlbum(_lojaImage.image, self, nil, nil);
    //Retorna para tela inicial
    [self.navigationController popToRootViewControllerAnimated:true];
}
    
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imagePicker.delegate = self;
    _nomeLabel.text = _nomeLojaDetalhes;
    _idLabel.text = _idLojaDetalhes;
    _telefoneLabel.text = _telefoneLojaDetalhes;
    _enderecoLabel.text = _enderecoLojaDetalhes;
    
  
}

    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
