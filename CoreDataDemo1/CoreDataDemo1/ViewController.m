//
//  ViewController.m
//  CoreDataDemo1
//
//  Created by qingyun on 16/2/24.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
@import CoreData;


@interface ViewController ()

@property (nonatomic, strong)NSManagedObjectContext *objectContext;//数据缓冲池
@property (nonatomic, strong)NSPersistentStoreCoordinator *psc;//数据存储协调器
@property (nonatomic, strong)NSPersistentStore *store;//数据存储


@end

@implementation ViewController
- (IBAction)addPerson:(id)sender {
    
    //添加记录
    
    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.objectContext];
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //初始化core data；
    [self initCoreData];
}

//搭建core data 框架
-(void)initCoreData{
    //加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    self.psc = psc;
    
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    //sqlite文件的路径
    NSURL *url = [NSURL fileURLWithPath:[documents stringByAppendingPathComponent:@"person.db"]];
    NSLog(@"%@", url);
    //psc添加存储器
    NSError *error;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    
    if (!store || error) {
        NSLog(@"%@", error);
    }
    self.store = store;
    
    //创建context，绑定psc
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:self.psc];
    
    self.objectContext = context;
    
    
    
    
}

@end
