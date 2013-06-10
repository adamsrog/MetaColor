//
//  RAGlobalDefinitions.h
//  RAKulerizer
//
//  Created by Roger Adams on 5/22/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#ifndef RAKulerizer_RAGlobalDefinitions_h
#define RAKulerizer_RAGlobalDefinitions_h

// colors/patterns
#define BACKGROUND_DARK [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_mosaic"]]
#define BACKGROUND_LIGHT [UIColor colorWithPatternImage:[UIImage imageNamed:@"whitey"]]
#define GENERATOR_CELL_SIZE CGSizeMake(8, 8)
#define METACOLOR_GREEN [UIColor colorWithRed:172.0/255.0 green:244.0/255.0 blue:0 alpha:1.0]

// kuler menu selection
#define KULER_USER_SAVED        0
#define KULER_RSS_NEWEST        1
#define KULER_RSS_POPULAR       2
#define KULER_RSS_HIGHEST_RATED 3
#define KULER_RSS_RANDOM        4

// kuler rss URLs
#define KULER_RSS_NEWEST_URL @"https://kuler-api.adobe.com/feeds/rss/get.cfm?listType=newest&timeSpan=0"
#define KULER_RSS_POPULAR_URL @"https://kuler-api.adobe.com/feeds/rss/get.cfm?listType=popular&timeSpan=0"
#define KULER_RSS_HIGHEST_RATED_URL @"https://kuler-api.adobe.com/feeds/rss/get.cfm?listType=rating&timeSpan=0"
#define KULER_RSS_RANDOM_URL @"https://kuler-api.adobe.com/feeds/rss/get.cfm?listType=random&timeSpan=0"

// KulerInfoViewController swatch positions
#define SWATCH_CENTER_Y  48.0
#define SWATCH1_CENTER_X 48.0
#define SWATCH1_BOUND_X  76.0
#define SWATCH2_CENTER_X 104.0
#define SWATCH2_BOUND_X  132.0
#define SWATCH3_CENTER_X 160.0
#define SWATCH3_BOUND_X  188.0
#define SWATCH4_CENTER_X 216.0
#define SWATCH4_BOUND_X  244.0
#define SWATCH5_CENTER_X 272.0
#define SWATCH5_BOUND_X  300.0

#endif
