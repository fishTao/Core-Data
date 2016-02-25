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
    [person setValue:@"xyz" forKey:@"name"];
    [person setValue:@12 forKey:@"age"];
    
    //设置属性
    NSManagedObject *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:self.objectContext];
    
    [card setValue:@"1234567890" forKey:@"no"];
    
    //设置关系
    
    [person setValue:card forKey:@"card"];
    [card setValue:person forKey:@"person"];
    
    NSError *error;
    
    //将缓冲区的修改，同步到数据库
    BOOL success = [self.objectContext save:&error];
    if (!success) {
        NSLog(@"%@",error);
    }
    
    
    
}

//查询内容
- (IBAction)select:(id)sender {
    
    NSArray *objects = [self selectPerson];
    
    
}

-(IBAction)change{
    NSArray *objects = [self selectPerson];
    NSManagedObject *person = objects.firstObject;
    [person setValue:@"qingyun" forKey:@"name"];
    
    //修改了缓冲池中的对象，更新缓冲池到数据库
    [self.objectContext save:nil];
}

-(IBAction)delete{
    NSArray *objects = [self selectPerson];
    [self.objectContext deleteObject:objects.firstObject];
    [self.objectContext save:nil];
}



-(NSArray *)selectPerson{
    //初始化一个查询对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //查询目标
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.objectContext];
    //设置排序条件
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    request.sortDescriptors = @[sort];
    
    //设置谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"x*"];
    request.predicate = predicate;
    
    //执行请求
    NSError *error;
    NSArray *objects = [self.objectContext executeFetchRequest:request error:&error];
    
    return objects;
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
