CoreDataManager
===============
Usage:
Change the 'kDataStoreName' constanct to match your data model name.

On the first call to obtain a context, the SQLite data store will be created:

    DataManager *dMgr = [DataManager sharedInstance];
    NSManagedObjectContext *cxt = [dMgr managedObjectContext];

Simple unit test
================
    
-(void)testMOC{
    // test for the success of obtaining a managed object context
    DataManager *dMgr = [DataManager sharedInstance];
    NSManagedObjectContext *cxt = [dMgr managedObjectContext];
    XCTAssert(cxt, @"Failed to create MOC");
}

-(void)testDataManagerUpdate{
    // test for a successful update to the persisted data store
    DataManager *dMgr = [DataManager sharedInstance];
    
    MyManagedObject *myObject = [NSEntityDescription insertNewObjectForEntityForName:@"MyManagedObject" inManagedObjectContext:[dMgr managedObjectContext]];
    [myObject setState:@"WV"];
    [myObject setName:@"New River Gorge"];
    [myObject setUsgs_id:@"1234"];
    
    XCTAssert([dMgr save], @"Failed to save managed object data");
}
    

