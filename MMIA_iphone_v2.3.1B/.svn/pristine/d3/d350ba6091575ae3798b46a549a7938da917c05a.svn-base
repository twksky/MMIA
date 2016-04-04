
#import "MMiaJsonUtil.h"
//#import <JSONKit/JSONKit.h>

@implementation MMiaJsonUtil


//SampleCode Begin

+ (GameGuideList *)parseGameGuideListFromJson:(NSDictionary *)jsonData
{
    @try{
        if (jsonData == nil || [jsonData count] == 0){
            return  nil;
        }
        
        GameGuideList *ggList = [[GameGuideList alloc] init];
        ggList.totalSize = [[jsonData objectForKey:@"total_size"] intValue];
        ggList.bannerUrl = [jsonData objectForKey:@"banner_url"];
        
        NSArray* itemListJson = [jsonData objectForKey:@"result"];
        NSMutableArray* itemList = [MMiaJsonUtil parseGameGuideListItemArrayFrom:itemListJson];
        ggList.items = itemList;
        return  ggList;
    }
    @catch (NSException *exception) {
        return nil;
    }
}


+ (NSMutableArray *)parseGameGuideListItemArrayFrom:(NSArray *) jsonData
{
    NSMutableArray *itemList = [[NSMutableArray alloc] init];
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  itemList;
        }
        
        for (NSDictionary *itemDict in jsonData) {
            GameGuideListItem *item = [[GameGuideListItem alloc] init];
            item.pageUrl = [itemDict objectForKey:@"page_url"];
            item.srcSiteName = [itemDict objectForKey:@"src_site_name"];
            item.srcSiteUrl = [itemDict objectForKey:@"src_site"];
            item.title = [itemDict objectForKey:@"title"];
            item.thumbUrl = [itemDict objectForKey:@"thumb_url"];
            item.sharelinkUrl = [itemDict objectForKey:@"sharelink_url"];
            item.gId = [[itemDict objectForKey:@"gid"] intValue];
            item.tags = [itemDict objectForKey:@"tags"];
            [itemList addObject:item];
        }
        
        return itemList;
    }
    @catch (NSException *exception) {
        return itemList;
    }
}

//SampleCode End

@end
