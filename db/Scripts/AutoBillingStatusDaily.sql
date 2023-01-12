USE [eTag365]
GO


BEGIN TRAN
BEGIN TRY

		DECLARE @UserId   int, @Count int, @CurrentDate  date, @Contact_Storage_Limit varchar(20)
     
		  SET @CurrentDate = CONVERT(VARCHAR(26), getdate(), 23)   

		  -- update Contact_Storage_Limit when subscription expired
	 
		  select Id, SubscriptionType INTO   #controltable from UserProfile where userTypecontact = '2' and (CONVERT(VARCHAR(26), StorageExpiredOn, 23) < CONVERT(VARCHAR(26), getdate(), 23))

		   WHILE EXISTS (SELECT *  FROM   #controltable) 
			BEGIN 
				SELECT TOP 1 @UserId = Id 
				FROM   #controltable 
				ORDER  BY Id ASC      

				select @Contact_Storage_Limit =  StoredContacts from UserPricing where UserPlans = (select SubscriptionType from UserProfile where Id= @UserId)

				update UserProfile set IsStorageSubscription = 0, Contact_Storage_Limit = @Contact_Storage_Limit where Id = @UserId

				update BillingPayment set IsStorageSubscription = 0, Contact_Storage_Limit = @Contact_Storage_Limit where UserId = @UserId


				DELETE #controltable    WHERE  Id = @UserId 
			
            
			END 

		 
		  DROP TABLE #controltable 

		   -- update billing status when subscription expired
		   
		   select Id INTO   #controltable2 from UserProfile 
			where userTypecontact = '2' and CONVERT(VARCHAR(26), SubscriptionExpiredOn, 23) < CONVERT(VARCHAR(26), getdate(), 23) 

		   WHILE EXISTS (SELECT *  FROM   #controltable2) 
			BEGIN 
				SELECT TOP 1 @UserId = Id 
				FROM   #controltable2 
				ORDER  BY Id ASC      

				update UserProfile set IsBillingComplete = 0, IsUserProfileComplete = 0 where Id = @UserId

				update BillingPayment set IsBillingComplete = 0  where UserId = @UserId


				DELETE #controltable2    WHERE  Id = @UserId 
			
            
			END 

		  DROP TABLE #controltable2 


		   -- update ReferralRecycleDate, YTD_ReferralUser after every year
		   
		   select Id INTO   #controltable3 from BillingPayment 
			where  CONVERT(VARCHAR(26), DATEADD(YEAR, 1, ReferralRecycleDate), 23) <= CONVERT(VARCHAR(26), getdate(), 23) 

		   WHILE EXISTS (SELECT *  FROM   #controltable3) 
			BEGIN 
				SELECT TOP 1 @UserId = Id 
				FROM   #controltable3 
				ORDER  BY Id ASC    

				update BillingPayment set YTD_ReferralUser = 0, ReferralRecycleDate = getdate()  where Id = @UserId


				DELETE #controltable3    WHERE  Id = @UserId 
			
            
			END 

		  DROP TABLE #controltable3 

COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH

