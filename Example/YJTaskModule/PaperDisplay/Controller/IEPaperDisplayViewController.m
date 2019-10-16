//
//  IEPaperDisplayViewController.m
//  LGIntellectExam
//
//  Created by dangwc on 2019/7/11.
//  Copyright © 2019 dangwc. All rights reserved.
//

#import "IEPaperDisplayViewController.h"
#import <YJTaskModule/YJPaperModel.h>
#import <YJTaskModule/YJTaskCarkView.h>
#import "IEPaperDisplayProtocol.h"
#import <YJTaskModule/YJTaskTitleView.h>
#import <YJTaskModule/YJTaskBigItem.h>
#import <YJTaskModule/YJListenView.h>
#import <SwipeView/SwipeView.h>
#import "IEPaperDisplayDataModel.h"
#import <YJExtensions/YJExtensions.h>
#import <Masonry/Masonry.h>

#define IE_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define IE_ScreenHeight [UIScreen mainScreen].bounds.size.height
#define IE_Navigation_height 64


@interface IEPaperDisplayViewController ()<IEPaperDisplayProtocol,SwipeViewDelegate,SwipeViewDataSource,YJTaskCarkViewDelegate>
@property (nonatomic,strong) IEPaperDisplayDataModel *dataModel;

@property (strong,nonatomic) YJListenView *listenView;
@property(nonatomic,strong) YJTaskTitleView *taskTitleV;
@property(nonatomic,strong) SwipeView *swipV;
/** 当前正在做的大题 */
@property (weak, nonatomic) YJBasePaperBigModel *currentItemModel;
/** 当前正在做的大题的下标 */
@property (assign, nonatomic) NSInteger currentItemIndex;
/** 当前正在做的大题的视图 */
@property (weak, nonatomic) YJTaskBigItem *currentItemView;
@property (nonatomic,strong) NSMutableDictionary<NSString *, YJTaskBigItem *> *itemViewPool;
@end

@implementation IEPaperDisplayViewController
- (instancetype)init{
    if (self = [super init]) {
        self.dataModel = [[IEPaperDisplayDataModel alloc] init];
        self.dataModel.ownController = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.dataModel loadPaperData];
    
}

- (void)loadPaperDataSuccess{
    self.dataModel.paperModel.yj_taskStageType = YJTaskStageTypeAnswer;
    [self.view addSubview:self.swipV];
    if (self.dataModel.paperModel.yj_isManualWorkRes) {
        [self.view addSubview:self.listenView];
        [self.listenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.left.equalTo(self.view);
            make.top.equalTo(self.view).offset(40+10);
            make.height.mas_equalTo(44);
        }];
        self.listenView.urlArr = @[[self.dataModel.paperModel yj_scantronAudio]];
    }
    self.taskTitleV.indexable = !self.dataModel.paperModel.yj_isTopicCardMode;
    
    [self.view addSubview:self.taskTitleV];
    self.taskTitleV.taskName = [NSString stringWithFormat:@"%@(总分%@)",@"预习作业",self.dataModel.paperModel.yj_taskScore];
    self.currentItemIndex = 0;
}

- (void)stopListen{
    [self.currentItemView stopListen];
    [self.listenView stopPlayer];
}
- (void)stopListenAtIndex:(NSInteger) index{
    YJBasePaperBigModel *bigModel = (YJBasePaperBigModel *)self.dataModel.paperModel.yj_bigTopicList[index];
    YJTaskBigItem *bigItem = [self.itemViewPool objectForKey:bigModel.yj_bigPoolID];
    [bigItem stopListen];
}

#pragma mark - Action
- (void)topicCarkAction{
    YJTaskCarkView *cardView = [YJTaskCarkView taskCarkView];
    YJBasePaperBigModel *bigModel = (YJBasePaperBigModel *)self.dataModel.paperModel.yj_bigTopicList[self.swipV.currentPage];
    YJTaskBigItem *bigItem = [self.itemViewPool objectForKey:bigModel.yj_bigPoolID];
    cardView.indexPath = [NSIndexPath indexPathForRow:bigModel.yj_bigIndex inSection:0];
    cardView.delegate = self;
    cardView.currentSmallIndex = bigItem.currentSmallIndex;
    cardView.isTopicCardMode = self.dataModel.paperModel.yj_isTopicCardMode;
    cardView.dataArr = self.dataModel.taskCarkModelArray;
    [cardView show];
}
#pragma mark - YJTaskCarkViewDelegate
- (void)yj_taskCarkView:(YJTaskCarkView *)cardView didSelectedItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataModel.paperModel.yj_isTopicCardMode) {
        self.currentItemView.currentSmallIndex = indexPath.section;
    }else{
        self.swipV.currentPage = indexPath.section;
        YJBasePaperBigModel *bigModel = (YJBasePaperBigModel *)self.dataModel.paperModel.yj_bigTopicList[indexPath.section];
        YJTaskBigItem *bigItem = [self.itemViewPool objectForKey:bigModel.yj_bigPoolID];
        bigItem.currentSmallIndex = indexPath.row;
    }
}
#pragma mark - SwipeView DataSource & Delegate
- (YJTaskBigItem *)viewForAnswerBigItemAtIndex:(NSInteger)index{
    YJBasePaperBigModel *bigModel = (YJBasePaperBigModel *)self.dataModel.paperModel.yj_bigTopicList[index];
    bigModel.yj_scantronHttp = [self.dataModel.paperModel yj_scantronHttp];
    bigModel.yj_scantronAudio = [self.dataModel.paperModel yj_scantronAudio];
    bigModel.yj_topicCarkMode = self.dataModel.paperModel.yj_isTopicCardMode;
    YJTaskBigItem *bigItem = [self.itemViewPool objectForKey:bigModel.yj_bigPoolID];
    if (!bigItem) {
        if (self.dataModel.paperModel.yj_isTopicCardMode) {
            bigItem =  [[YJTaskBigItem alloc] initWithFrame:self.swipV.bounds bigPModel:bigModel taskStageType: [self.dataModel.paperModel yj_taskStageType] taskPModel:self.dataModel.paperModel];
        }else{
            bigItem =  [[YJTaskBigItem alloc] initWithFrame:self.swipV.bounds bigPModel:bigModel taskStageType: [self.dataModel.paperModel yj_taskStageType]];
        }
        [self.itemViewPool setObject:bigItem forKey:bigModel.yj_bigPoolID];
    }
    if (bigItem.taskStageType != self.dataModel.paperModel.yj_taskStageType) {
        bigItem.taskStageType = self.dataModel.paperModel.yj_taskStageType;
    }
    bigItem.currentBigIndex = index;
    bigItem.totalBigCount = self.dataModel.paperModel.yj_bigTopicList.count;
    bigItem.ownSwipeView = self.swipV;
    self.currentItemModel = bigModel;
    self.currentItemView = bigItem;
    return bigItem;
}
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    if (self.dataModel.paperModel.yj_isTopicCardMode) {
        return 1;
    }
    return self.dataModel.paperModel.yj_bigTopicList.count;
}
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view) {
        view = [[UIView alloc]initWithFrame:self.swipV.bounds];
    } else {
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [view addSubview:[self viewForAnswerBigItemAtIndex:index]];
    return view;
}
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.swipV.bounds.size;
}
- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    [self stopListenAtIndex:self.currentItemIndex];
    self.currentItemIndex = swipeView.currentItemIndex;
}
#pragma mark - Getter
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex{
    _currentItemIndex = currentItemIndex;
    if (!self.dataModel.paperModel.yj_isTopicCardMode) {
        YJBasePaperBigModel *bigModel = (YJBasePaperBigModel *)self.dataModel.paperModel.yj_bigTopicList[currentItemIndex];
        
        self.taskTitleV.topicIndexAttr = [NSMutableAttributedString yj_AttributedStringByHtmls:@[[NSString stringWithFormat:@"%li",bigModel.yj_bigIndex+1],[NSString stringWithFormat:@"/%li",self.dataModel.paperModel.yj_bigTopicList.count]] colors:@[[UIColor darkGrayColor],[UIColor redColor]] fonts:@[@(16),@(13)]];
    }
}
- (YJListenView *)listenView{
    if (!_listenView) {
        _listenView = [[YJListenView alloc] initWithFrame:CGRectZero];
    }
    return _listenView;
}
- (NSMutableDictionary<NSString *,YJTaskBigItem *> *)itemViewPool{
    if (!_itemViewPool) {
        _itemViewPool = [NSMutableDictionary dictionary];
    }
    return _itemViewPool;
}
- (YJTaskTitleView *)taskTitleV{
    if (!_taskTitleV) {
        _taskTitleV = [[YJTaskTitleView alloc] initWithFrame:CGRectMake(0, 0, IE_ScreenWidth, 40)];
        __weak typeof(self) weakSelf = self;
        _taskTitleV.topicCardClickBlock = ^{
            [weakSelf topicCarkAction];
        };
    }
    return _taskTitleV;
}
- (SwipeView *)swipV{
    if (!_swipV) {
        CGFloat y = 40 + (self.dataModel.paperModel.yj_isManualWorkRes ? 54 : 0) ;
        _swipV = [[SwipeView alloc]initWithFrame:CGRectMake(0, y, IE_ScreenWidth,IE_ScreenHeight - y - IE_Navigation_height)];
        _swipV.pagingEnabled = YES;
        _swipV.dataSource = self;
        _swipV.delegate = self;
        _swipV.bounces = NO;
    }
    return _swipV;
}

@end
