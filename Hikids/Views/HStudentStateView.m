//
//  HStudentStateView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/11.
//

#import "HStudentStateView.h"

@interface HStudentStateView()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;

@end

@implementation HStudentStateView

- (instancetype)initWithStudentArray:(NSArray *)array
{
    if (self = [super init]) {
        
        self.array = array;
        
        
    }
    return self;
}

@end
