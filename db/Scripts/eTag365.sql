USE [eTag365]
GO
/****** Object:  UserDefinedTableType [dbo].[tblContactInfo]    Script Date: 1/12/2023 12:37:13 AM ******/
IF NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'tblContactInfo' AND ss.name = N'dbo')
CREATE TYPE [dbo].[tblContactInfo] AS TABLE(
	[FirstName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[Address] [nvarchar](150) NULL,
	[Address1] [nvarchar](150) NULL,
	[Region] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[State] [varchar](30) NULL,
	[City] [varchar](30) NULL,
	[Zip] [varchar](10) NULL,
	[Phone] [varchar](30) NULL,
	[WorkPhone] [varchar](30) NULL,
	[WorkPhoneExt] [varchar](30) NULL,
	[Fax] [varchar](30) NULL,
	[IsActive] [bit] NULL,
	[RefPhone] [varchar](30) NULL,
	[Title] [varchar](100) NULL,
	[CreatedBy] [varchar](30) NULL,
	[CreatedDate] [datetime] NULL,
	[TypeOfContact] [varchar](300) NULL,
	[CompanyName] [varchar](100) NULL,
	[Category] [varchar](30) NULL,
	[IsEmailFlow] [smallint] NULL,
	[Website] [varchar](100) NULL
)
GO
/****** Object:  StoredProcedure [dbo].[SP_GetID]    Script Date: 1/12/2023 12:37:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[SP_GetID] 
	@ObjectID varchar(255), @ItemID varchar(255), @IDForYear int=NULL,
	@IDForMonth int=NULL, @IDForDate datetime=NULL, @NewID int=NULL output
AS
	SET NOCOUNT ON;

	IF @IDForDate IS NOT NULL
	  BEGIN
		--Current ID
		SELECT @NewID = CurrentID FROM GlobalID 
		WHERE ObjectID = @ObjectID AND ItemID = @ItemID AND 
		  IDForDate = @IDForDate AND IDForMonth IS NULL AND IDForYear IS NULL 

		--If not exist Set NewID=1 and Save in table
		IF @NewID IS NULL
	      BEGIN
			SET @NewID = 1
			INSERT INTO GlobalID(ObjectID, ItemID, IDForYear, IDForMonth, IDForDate, CurrentID)
			VALUES(@ObjectID, @ItemID, @IDForYear, @IDForMonth, @IDForDate, 2)
		  END
		ELSE
	      BEGIN
			UPDATE GlobalID SET CurrentID = CurrentID + 1
			WHERE ObjectID = @ObjectID AND ItemID = @ItemID AND 
			  IDForDate = @IDForDate AND IDForMonth IS NULL AND IDForYear IS NULL 
		  END

		SET NOCOUNT OFF;
		RETURN
	  END

	--Generate Squence Monthly
	IF @IDForMonth IS NOT NULL
	  BEGIN
		SELECT @NewID = CurrentID FROM GlobalID 
		WHERE ObjectID = @ObjectID AND ItemID = @ItemID AND 
		  IDForMonth = @IDForMonth AND IDForDate IS NULL AND IDForYear IS NULL 
		
		--If not exist Set NewID=1 and Save in table
		IF @NewID IS NULL
	      BEGIN
			SET @NewID = 1
			INSERT INTO GlobalID(ObjectID, ItemID, IDForYear, IDForMonth, IDForDate, CurrentID)
			VALUES(@ObjectID, @ItemID, @IDForYear, @IDForMonth, @IDForDate, 2)
		  END
		ELSE
	      BEGIN
			UPDATE GlobalID SET CurrentID = CurrentID + 1
			WHERE ObjectID = @ObjectID AND ItemID = @ItemID AND 
			  IDForMonth = @IDForMonth AND IDForDate IS NULL AND IDForYear IS NULL 
		  END

		SET NOCOUNT OFF;
		RETURN
	  END
	
	--Generate Squence Yearly
	declare @NewIdFromUnit int
	IF @IDForYear IS NOT NULL
	  BEGIN
	  
	 
	 
	--SELECT CONVERT(int, RIGHT (''1000000''+''5'', 6))
		SELECT @NewID = CurrentID FROM GlobalID WHERE ObjectID = @ObjectID AND ItemID = @ItemID 

		--If not exist Set NewID=1 and Save in table
		IF @NewID IS NULL
	      BEGIN
			SET @NewID = 1
			INSERT INTO GlobalID(ObjectID, ItemID, IDForYear, IDForMonth, IDForDate, CurrentID)
			VALUES(@ObjectID, @ItemID, @IDForYear, @IDForMonth, @IDForDate, 2)
		  END
		ELSE
	      BEGIN
		   if(@ObjectID =''User'')
				  begin	 
					set @NewIdFromUnit=( select isnull(CONVERT(int, RIGHT (''100000000000''+CONVERT(varchar,max(Serial)), 11)),0)   from dbo.userprofile )
					
					UPDATE GlobalID SET CurrentID = @NewIdFromUnit + 1	WHERE ObjectID = @ObjectID AND ItemID = @ItemID 
					
					set @NewID = @NewIdFromUnit + 1
				  end
		  else if(@ObjectID =''Dealer'')
				  begin	 
					  set @NewIdFromUnit=( select isnull(CONVERT(int, RIGHT (''100000''+CONVERT(varchar,max(serialCode)), 5)),0)    from Dealer_SalesPartner)
					  
					  UPDATE GlobalID SET CurrentID = @NewIdFromUnit + 1 WHERE ObjectID = @ObjectID AND ItemID = @ItemID 
					  
					  set @NewID = @NewIdFromUnit + 1
				  end
		   else if(@ObjectID =''Billing'')
				  begin	 
					   set @NewIdFromUnit=( select isnull(CONVERT(int, RIGHT (''100000000000''+CONVERT(varchar,max(Serial)), 11)),0)   from dbo.PaymentHistory)
					   
					   UPDATE GlobalID SET CurrentID = @NewIdFromUnit + 1 WHERE ObjectID = @ObjectID AND ItemID = @ItemID 
					   
					   set @NewID = @NewIdFromUnit + 1
				  end
		  else if(@ObjectID =''Account'')
				  begin	 
				  set @NewIdFromUnit=( select isnull(CONVERT(int, RIGHT (''100000000000''+CONVERT(varchar,max(Serial)), 11)),0)   from dbo.FinancialTransaction )
				  UPDATE GlobalID SET CurrentID = @NewIdFromUnit + 1
						WHERE ObjectID = @ObjectID AND ItemID = @ItemID 
						  set @NewID = @NewIdFromUnit + 1
				  end
		  else 
				  begin
					  UPDATE GlobalID SET CurrentID = CurrentID + 1 WHERE ObjectID = @ObjectID AND ItemID = @ItemID  
				  end  

			
		  END

		SET NOCOUNT OFF;
		RETURN
	  END
	
	--Generate Squence
	IF @IDForDate IS NULL AND @IDForMonth IS NULL AND @IDForYear IS NULL
	  BEGIN
		SELECT @NewID = CurrentID FROM GlobalID 
		WHERE ObjectID = @ObjectID AND ItemID = @ItemID 

		--If not exist Set NewID=1 and Save in table
		IF @NewID IS NULL
		  BEGIN
			SET @NewID = 1
			INSERT INTO GlobalID(ObjectID, ItemID, IDForYear, IDForMonth, IDForDate, CurrentID)
			VALUES(@ObjectID, @ItemID, @IDForYear, @IDForMonth, @IDForDate, 2)
		  END
		ELSE
		  BEGIN
			UPDATE GlobalID SET CurrentID = CurrentID + 1
			WHERE ObjectID = @ObjectID AND ItemID = @ItemID 
		  END

		SET NOCOUNT OFF;
		RETURN
	  END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Calculate_Commission_Dealer_Monthly]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Calculate_Commission_Dealer_Monthly]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[usp_Calculate_Commission_Dealer_Monthly]
-- exec usp_Calculate_Commission_Dealer_Monthly
as
	begin

	SET NOCOUNT ON
	SET XACT_ABORT ON

	BEGIN TRAN
	BEGIN TRY

		-- Global variable declarateion --
	declare @commissionMonth int, @commissionYear int  

	
	if MONTH(GETDATE()) = 1
		begin
			set @commissionYear  = YEAR(GETDATE()) -1
			set @commissionMonth= 12
		end
	else
		begin
			set @commissionYear  = YEAR(GETDATE())
			set @commissionMonth= MONTH(GETDATE()) -1
		end
 
	 --- Cursor variable declaretion ----
	 declare @userId int , @PhoneNo varchar(20),@serial varchar(20) 

	 DECLARE cur_commission CURSOR FOR
	-- get all user from user table 
	select Id,Phone,Serial from UserProfile where IsBillingComplete=1 and UserTypeContact=3 
	OPEN cur_commission 
	FETCH NEXT FROM cur_commission INTO 	@userId,@PhoneNo,@serial 		
			
				WHILE @@FETCH_STATUS =0
				BEGIN		
				declare @ZipCode varchar(20),@CommissionForZipCode decimal(18,3)
					Declare cur_getzipCode cursor for
					select zipCode,commissionRate from UserProfile u inner join Dealer_SalesPartner_DetailsZipCodeCoverage z 
					on z.dealerSalesPartnerId=u.Serial
					where u.Serial=@serial
					open cur_getzipCode
					FETCH NEXT FROM cur_getzipCode INTO @ZipCode,@CommissionForZipCode
					WHILE @@FETCH_STATUS =0
					BEGIN	
				---- Logic goes here -------
				------ First get referral user for a single Dealer -----
				declare @GiverPhone varchar(20), @GiverUserId int
					Declare cur_referalUser cursor for
					select u.Id,u.Phone from  UserProfile u inner join BillingPayment b on u.Id=b.UserId
					where CONVERT(VARCHAR(26), b.CreateDate, 23) <= CONVERT(VARCHAR(26), DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)), 23)  
					--where MONTH(b.CreateDate) <= @commissionMonth and YEAR(b.CreateDate) <= @commissionYear  
					--and r.GetterPhone=@PhoneNo	
					and u.Zip=@ZipCode and u.UserTypeContact=2 and u.Serial <> @serial	
					open cur_referalUser
					FETCH NEXT FROM cur_referalUser INTO @GiverUserId, @GiverPhone
					WHILE @@FETCH_STATUS =0
					BEGIN	
					--- 
					declare @ReferalUserBillPayDate datetime,@SubscriptionType varchar(30),@packageamount decimal(18,2),@MonthlycommissionAmount decimal(18,2)
					,@commissionCountedMonth int,@achivedcommitionMonthCount int,@ReferalEndDate datetime
					--- core login here----
					select @ReferalUserBillPayDate=b.CreateDate, @packageamount = b.GrossAmount, @SubscriptionType = b.SubscriptionType,@ReferalEndDate=b.ReferralEndDate from BillingPayment b where b.UserPhone=@GiverPhone
					if CONVERT(VARCHAR(26), @ReferalUserBillPayDate, 23) <= CONVERT(VARCHAR(26), DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)), 23) 
					begin
					-- now get subscriptiontype, subscriptionamount				
						--if @SubscriptionType = ''Basic''
						--	begin
						--		select @packageamount=MonthlyCosts from UserPricing where Id=1
						--	end
						--else if(@SubscriptionType = ''Silver'')
						--	begin
						--		select @packageamount=MonthlyCosts from UserPricing where Id=2
						--	end
						--else
						--	begin
						--		select @packageamount=MonthlyCosts from UserPricing where Id=3
						--	end		
								
						set @MonthlycommissionAmount = (@packageamount*(@CommissionForZipCode/100))/12
						-- now check did getter phone user have this amount from commission month
						-- commission will be count for this user (currentmonth-1) - @ReferalUserBillPayDate
						set @commissionCountedMonth = (MONTH(GETDATE()) - MONTH(@ReferalUserBillPayDate))  -- May - February = February,March,April
						--select @achivedcommitionMonthCount = COUNT(id) from ReferralTransaction where GetterPhone=@PhoneNo and GiverPhone=@GiverPhone and CommissionFor=''Dealer''
					
						DECLARE @count INT,@ReferalUserBillPayDateMonthCount int;
						SET @count = 1;
						set @ReferalUserBillPayDateMonthCount = MONTH(@ReferalUserBillPayDate);--@ReferalEndDate
						while @count <= @commissionCountedMonth and @MonthlycommissionAmount > 0
						begin
						-- check is it the last month and year for the referral user 
						if ((@commissionMonth = MONTH(@ReferalEndDate) and @commissionYear =year(@ReferalEndDate)) OR @ReferalEndDate IS NULL)
							begin
								set @count =@count +1;
								set  @ReferalUserBillPayDateMonthCount =  @ReferalUserBillPayDateMonthCount +1;
							end
						else
							begin
									declare @note varchar(200), @commissiondate datetime, @BillYear int
									set @BillYear = case when YEAR(@ReferalUserBillPayDate) <= @commissionYear then YEAR(@ReferalUserBillPayDate) else @commissionYear end

									set @commissiondate = convert(datetime, (cast(@BillYear as varchar(10)) + ''-'' + cast(@ReferalUserBillPayDateMonthCount as varchar(10)) + ''-01''));
									set @note = ''dealer commission added for '' + cast(DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1) as varchar(20)) + '' '' + cast(@BillYear as varchar(10))

								if not EXISTS (select id from ReferralTransaction r where CommissionFor=''Dealer'' and GetterPhone=@PhoneNo and GiverPhone=@GiverPhone and r.Month = DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1) and @commissionYear=YEAR(@ReferalUserBillPayDate))
									begin
										INSERT INTO [dbo].[ReferralTransaction]
									   (GiverPhone
									   ,GetterPhone
									   ,TransactionDate
									   ,PayorAmount
									   ,Month
									   ,Year
									   ,Remarks
									   ,Description
									   ,CreatedDate
									   ,CommissionMonthDate
									   ,IsPaid
									   ,CommissionFor
									   ,ZipCode)
										--select @GiverPhone,@PhoneNo,getdate(),@MonthlycommissionAmount,DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1),YEAR(GETDATE()),''commission added'',GETDATE(),DATEADD(month, -1, getdate()),0,''Dealer'',@ZipCode
										select @GiverPhone,@PhoneNo,DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)),@MonthlycommissionAmount,DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1),@BillYear,''dealer commission added'',@note,GETDATE(),@commissiondate,0,''Dealer'',@ZipCode

										--- NOW update part
						
									end
									set @count =@count +1;
									set  @ReferalUserBillPayDateMonthCount =  @ReferalUserBillPayDateMonthCount +1;
							end
						--if ((@commissionMonth != MONTH(@ReferalEndDate) and @commissionYear !=year(@ReferalEndDate)) OR @ReferalEndDate IS NULL)
						--begin				
						
						--	--Select DateName( month , DateAdd( month , 2 , 0 ) - 1 )

						--end
						end -- while end

					end

					FETCH NEXT FROM cur_referalUser INTO @GiverUserId, @GiverPhone		
					END
				   CLOSE cur_referalUser
				   DEALLOCATE cur_referalUser

				   FETCH NEXT FROM cur_getzipCode INTO @ZipCode,@CommissionForZipCode		
					END
				   CLOSE cur_getzipCode
				   DEALLOCATE cur_getzipCode
				FETCH NEXT FROM cur_commission INTO @userId,@PhoneNo,@serial 
			
				END
				CLOSE cur_commission
				DEALLOCATE cur_commission
	

	COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH

	--BEGIN TRAN
	--BEGIN TRY

	--	-- Global variable declarateion --
	--declare @commissionMonth int, @commissionYear int  

	
	--if MONTH(GETDATE()) = 1
	--	begin
	--		set @commissionYear  = YEAR(GETDATE()) -1
	--		set @commissionMonth= 12
	--	end
	--else
	--	begin
	--		set @commissionYear  = YEAR(GETDATE())
	--		set @commissionMonth= MONTH(GETDATE()) -1
	--	end
 
	-- --- Cursor variable declaretion ----
	-- declare @userId int , @PhoneNo varchar(20),@serial varchar(20) 

	-- DECLARE cur_commission CURSOR FOR
	---- get all user from user table 
	--select Id,Phone,Serial from UserProfile where IsBillingComplete=1 and UserTypeContact=3 
	--OPEN cur_commission 
	--FETCH NEXT FROM cur_commission INTO 	@userId,@PhoneNo,@serial 		
			
	--			WHILE @@FETCH_STATUS =0
	--			BEGIN		
	--			declare @ZipCode varchar(20),@CommissionForZipCode decimal(18,3)
	--				Declare cur_getzipCode cursor for
	--				select zipCode,commissionRate from UserProfile u inner join Dealer_SalesPartner_DetailsZipCodeCoverage z 
	--				on z.dealerSalesPartnerId=u.Serial
	--				where u.Serial=@serial
	--				open cur_getzipCode
	--				FETCH NEXT FROM cur_getzipCode INTO @ZipCode,@CommissionForZipCode
	--				WHILE @@FETCH_STATUS =0
	--				BEGIN	
	--			---- Logic goes here -------
	--			------ First get referral user for a single Dealer -----
	--			declare @GiverPhone varchar(20), @GiverUserId int
	--				Declare cur_referalUser cursor for
	--				select u.Id,u.Phone from  UserProfile u inner join BillingPayment b on u.Id=b.UserId
	--				where CONVERT(VARCHAR(26), b.CreateDate, 23) <= CONVERT(VARCHAR(26), DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)), 23)  
	--				--where MONTH(b.CreateDate) <= @commissionMonth and YEAR(b.CreateDate) <= @commissionYear  
	--				--and r.GetterPhone=@PhoneNo	
	--				and u.Zip=@ZipCode and u.UserTypeContact=2 and u.Serial <> @serial	
	--				open cur_referalUser
	--				FETCH NEXT FROM cur_referalUser INTO @GiverUserId, @GiverPhone
	--				WHILE @@FETCH_STATUS =0
	--				BEGIN	
	--				--- 
	--				declare @ReferalUserBillPayDate datetime,@SubscriptionType varchar(30),@packageamount decimal(18,2),@MonthlycommissionAmount decimal(18,4)
	--				,@commissionCountedMonth int,@achivedcommitionMonthCount int,@ReferalEndDate datetime
	--				--- core login here----
	--				select @ReferalUserBillPayDate=b.CreateDate, @packageamount = b.GrossAmount, @SubscriptionType = b.SubscriptionType,@ReferalEndDate=b.ReferralEndDate from BillingPayment b where b.UserPhone=@GiverPhone
	--				if CONVERT(VARCHAR(26), @ReferalUserBillPayDate, 23) <= CONVERT(VARCHAR(26), DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)), 23) 
	--				begin
	--				-- now get subscriptiontype, subscriptionamount				
	--					--if @SubscriptionType = ''Basic''
	--					--	begin
	--					--		select @packageamount=MonthlyCosts from UserPricing where Id=1
	--					--	end
	--					--else if(@SubscriptionType = ''Silver'')
	--					--	begin
	--					--		select @packageamount=MonthlyCosts from UserPricing where Id=2
	--					--	end
	--					--else
	--					--	begin
	--					--		select @packageamount=MonthlyCosts from UserPricing where Id=3
	--					--	end		
								
	--					set @MonthlycommissionAmount = (@packageamount*(@CommissionForZipCode/100))/12
	--					-- now check did getter phone user have this amount from commission month
	--					-- commission will be count for this user (currentmonth-1) - @ReferalUserBillPayDate
	--					set @commissionCountedMonth = (MONTH(GETDATE()) - MONTH(@ReferalUserBillPayDate))+1-- May - February = February,March,April
	--					--select @achivedcommitionMonthCount = COUNT(id) from ReferralTransaction where GetterPhone=@PhoneNo and GiverPhone=@GiverPhone and CommissionFor=''Dealer''
					
	--					DECLARE @count INT,@ReferalUserBillPayDateMonthCount int;
	--					SET @count = 1;
	--					set @ReferalUserBillPayDateMonthCount = MONTH(@ReferalUserBillPayDate);--@ReferalEndDate
	--					while @count <> @commissionCountedMonth 
	--					begin
	--					-- check is it the last month and year for the referral user 
	--					if ((@commissionMonth = MONTH(@ReferalEndDate) and @commissionYear =year(@ReferalEndDate)) OR @ReferalEndDate IS NULL)
	--						begin
	--							set @count =@count +1;
	--							set  @ReferalUserBillPayDateMonthCount =  @ReferalUserBillPayDateMonthCount +1;
	--						end
	--					else
	--						begin
	--							if not EXISTS (select id from ReferralTransaction r where CommissionFor=''Dealer'' and GetterPhone=@PhoneNo and GiverPhone=@GiverPhone and r.Month = DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1) and @commissionYear=YEAR(@ReferalUserBillPayDate))
	--								begin
	--									INSERT INTO [dbo].[ReferralTransaction]
	--								   ([GiverPhone]
	--								   ,[GetterPhone]
	--								   ,[TransactionDate]
	--								   ,[PayorAmount]
	--								   ,[Month]
	--								   ,[Year]
	--								   ,[Remarks]
	--								   ,[CreatedDate]
	--								   ,[CommissionMonthDate]
	--								   ,IsPaid
	--									,CommissionFor
	--									,ZipCode)
	--									select @GiverPhone,@PhoneNo,getdate(),@MonthlycommissionAmount,DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1),YEAR(GETDATE()),''commission added'',GETDATE(),DATEADD(month, -1, getdate()),0,''Dealer'',@ZipCode

	--									--- NOW update part
						
	--								end
	--								set @count =@count +1;
	--								set  @ReferalUserBillPayDateMonthCount =  @ReferalUserBillPayDateMonthCount +1;
	--						end
	--					--if ((@commissionMonth != MONTH(@ReferalEndDate) and @commissionYear !=year(@ReferalEndDate)) OR @ReferalEndDate IS NULL)
	--					--begin				
						
	--					--	--Select DateName( month , DateAdd( month , 2 , 0 ) - 1 )

	--					--end
	--					end -- while end

	--				end

	--				FETCH NEXT FROM cur_referalUser INTO @GiverUserId, @GiverPhone		
	--				END
	--			   CLOSE cur_referalUser
	--			   DEALLOCATE cur_referalUser

	--			   FETCH NEXT FROM cur_getzipCode INTO @ZipCode,@CommissionForZipCode		
	--				END
	--			   CLOSE cur_getzipCode
	--			   DEALLOCATE cur_getzipCode
	--			FETCH NEXT FROM cur_commission INTO @userId,@PhoneNo,@serial 
			
	--			END
	--			CLOSE cur_commission
	--			DEALLOCATE cur_commission
	

	--COMMIT TRAN
	--END TRY
	--BEGIN CATCH
	--	ROLLBACK TRAN
	--END CATCH

	end

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Calculate_Commission_User_Monthly]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Calculate_Commission_User_Monthly]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[usp_Calculate_Commission_User_Monthly]
-- exec usp_Calculate_Commission_User_Monthly
as
	begin
		SET NOCOUNT ON
		SET XACT_ABORT ON

		BEGIN TRAN
		BEGIN TRY

			-- Global variable declarateion --
			declare @commissionMonth int, @commissionYear int  

				if MONTH(GETDATE()) = 1
					begin
						set @commissionYear  = YEAR(GETDATE()) -1
						set @commissionMonth= 12
					end
				else
					begin
						set @commissionYear  = YEAR(GETDATE())
						set @commissionMonth= MONTH(GETDATE()) -1
					end
 
				 --- Cursor variable declaretion ----
				 declare @userId int, @PhoneNo varchar(20) 

	 	 		 DECLARE cur_commission CURSOR FOR
				-- get all user from user table 
				select Id,Phone from UserProfile where IsBillingComplete=1 and UserTypeContact=2 
				OPEN cur_commission 
				FETCH NEXT FROM cur_commission INTO 	@userId,@PhoneNo 		
			
				WHILE @@FETCH_STATUS =0
																																																																																																																																																																																																																																																																			BEGIN			
				---- Logic goes here -------
				------ First get referral user for a single user -----
				Declare @GiverPhone varchar(20), @GiverUserId int
				declare @ReferalUserBillPayDate datetime, @SubscriptionType varchar(30), @packageamount decimal(18,2)
						,@MonthlycommissionAmount decimal(18,2), @commissionCountedMonth int
						,@achivedcommitionMonthCount int, @ReferalEndDate datetime

				Declare cur_referalUser cursor for
			    select u.Id,r.GiverPhone, r.StartDate, r.MTD_Commission,r.EndDate  from ReferralAccount r inner join UserProfile u 
				on r.GetterPhone = u.Phone
				where CONVERT(VARCHAR(26), r.EndDate, 23) >= CONVERT(VARCHAR(26), DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)), 23) 
				and r.GetterPhone=@PhoneNo	
					
				--where MONTH( r.CreatedDate) <= @commissionMonth and YEAR(r.CreatedDate) <= @commissionYear  and r.GetterPhone=@PhoneNo		
					
					open cur_referalUser
					FETCH NEXT FROM cur_referalUser INTO @GiverUserId, @GiverPhone, @ReferalUserBillPayDate, @packageamount,@ReferalEndDate
					WHILE @@FETCH_STATUS =0
					BEGIN									

					--- core login here----
					--select @ReferalUserBillPayDate=b.CreateDate,@packageamount = b.MTD_Commission,@SubscriptionType = b.SubscriptionType,@ReferalEndDate=b.ReferralEndDate from BillingPayment b where b.UserPhone=@GiverPhone
					
					-- DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)) LastDayPreviousMonthWithTimeStamp
					if CONVERT(VARCHAR(26), @ReferalUserBillPayDate, 23) <= CONVERT(VARCHAR(26), DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)), 23) 
					 --MONTH(@ReferalUserBillPayDate) <= @commissionMonth
																																																																	
					begin
					
					-- now get subscriptiontype, subscriptionamount	
								
					--if @SubscriptionType = ''Basic''
					--	begin
					--		select @packageamount=MonthlyCosts from UserPricing where Id=1
					--	end
					--else if(@SubscriptionType = ''Silver'')
					--	begin
					--		select @packageamount=MonthlyCosts from UserPricing where Id=2
					--	end
					--else
					--	begin
					--		select @packageamount=MonthlyCosts from UserPricing where Id=3
					--	end		

						set @MonthlycommissionAmount = @packageamount		

						--set @MonthlycommissionAmount = (@packageamount*0.05)/12
						-- now check did getter phone user have this amount from commission month
						-- commission will be count for this user (currentmonth-1) - @ReferalUserBillPayDate
					
						set @commissionCountedMonth = (MONTH(GETDATE()) - MONTH(@ReferalUserBillPayDate)) -- May - February = February,March,April
						--select @achivedcommitionMonthCount = COUNT(id) from ReferralTransaction where GetterPhone=@PhoneNo and GiverPhone=@GiverPhone
					
						DECLARE @count INT,@ReferalUserBillPayDateMonthCount int;
						SET @count = 1;
						set @ReferalUserBillPayDateMonthCount = MONTH(@ReferalUserBillPayDate);--@ReferalEndDate
						while @count <= @commissionCountedMonth and @MonthlycommissionAmount > 0
							begin
							-- check is it the last month and year for the referral user 
							if ((@commissionMonth = MONTH(@ReferalEndDate) and @commissionYear =year(@ReferalEndDate)) OR @ReferalEndDate IS NULL)
								begin
									set @count =@count +1;
									set  @ReferalUserBillPayDateMonthCount =  @ReferalUserBillPayDateMonthCount +1;
								end
							else
								begin
									declare @note varchar(200), @commissiondate datetime, @BillYear int
									set @BillYear = case when YEAR(@ReferalUserBillPayDate) <= @commissionYear then YEAR(@ReferalUserBillPayDate) else @commissionYear end

									set @commissiondate = convert(datetime, (cast(@BillYear as varchar(10)) + ''-'' + cast(@ReferalUserBillPayDateMonthCount as varchar(10)) + ''-01''));
									set @note = ''commission added for '' + cast(DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1) as varchar(20)) + '' '' + cast(@BillYear as varchar(10))

									if not EXISTS (select id from ReferralTransaction r where CommissionFor=''User'' and GetterPhone=@PhoneNo and GiverPhone=@GiverPhone and r.Month = DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1) and @commissionYear=YEAR(@ReferalUserBillPayDate) )
										begin
											INSERT INTO [dbo].[ReferralTransaction]
											   (GiverPhone
											   ,GetterPhone
											   ,TransactionDate
											   ,PayorAmount
											   ,Month
											   ,Year
											   ,Remarks
											   ,Description
											   ,CreatedDate
											   ,CommissionMonthDate
											   ,IsPaid
											   ,CommissionFor)
												select @GiverPhone,@PhoneNo,DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)),@MonthlycommissionAmount,DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1),@BillYear,''commission added'',@note,GETDATE(),@commissiondate,0,''User''

											--- NOW update part
						
										end
										set @count =@count +1;
										set  @ReferalUserBillPayDateMonthCount =  @ReferalUserBillPayDateMonthCount +1;

								end
							end -- while end
						-- Update total referal count to billing table
						declare @TotalReferalCount int,@YTDcommissionOwed decimal(18,4)

						--set @TotalReferalCount =(select COUNT(distinct GiverPhone) from ReferralTransaction where GetterPhone=@PhoneNo)
					
						--update BillingPayment set Total_ReferralUser=@TotalReferalCount where UserPhone=@PhoneNo

						set @YTDcommissionOwed =(select isnull(sum(PayorAmount),0) from ReferralTransaction where CommissionFor=''User'' and GetterPhone=@PhoneNo and GiverPhone=@GiverPhone)
					
						update ReferralAccount set YTD_CommissionOwed=@YTDcommissionOwed,  MTD_CommissionOwed = @packageamount, LastTransactionDate = GETDATE()  where GetterPhone=@PhoneNo and GiverPhone=@GiverPhone


					end

					--FETCH NEXT FROM cur_referalUser INTO @GiverUserId, @GiverPhone		
					FETCH NEXT FROM cur_referalUser INTO @GiverUserId, @GiverPhone, @ReferalUserBillPayDate, @packageamount,@ReferalEndDate
					END
					CLOSE cur_referalUser
					DEALLOCATE cur_referalUser


					FETCH NEXT FROM cur_commission INTO @userId,@PhoneNo 
			
					END
					CLOSE cur_commission
					DEALLOCATE cur_commission


		COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH

		--BEGIN TRAN
		--BEGIN TRY

		--	-- Global variable declarateion --
		--	declare @commissionMonth int, @commissionYear int  

		--		if MONTH(GETDATE()) = 1
		--			begin
		--				set @commissionYear  = YEAR(GETDATE()) -1
		--				set @commissionMonth= 12
		--			end
		--		else
		--			begin
		--				set @commissionYear  = YEAR(GETDATE())
		--				set @commissionMonth= MONTH(GETDATE()) -1
		--			end
 
		--		 --- Cursor variable declaretion ----
		--		 declare @userId int, @PhoneNo varchar(20) 

	 --	 		 DECLARE cur_commission CURSOR FOR
		--		-- get all user from user table 
		--		select Id,Phone from UserProfile where IsBillingComplete=1 and UserTypeContact=2 
		--		OPEN cur_commission 
		--		FETCH NEXT FROM cur_commission INTO 	@userId,@PhoneNo 		
			
		--		WHILE @@FETCH_STATUS =0
		--																																																																																																																																																																																																																																																																	BEGIN			
		--		---- Logic goes here -------
		--		------ First get referral user for a single user -----
		--		Declare @GiverPhone varchar(20), @GiverUserId int
		--		declare @ReferalUserBillPayDate datetime, @SubscriptionType varchar(30), @packageamount decimal(18,2)
		--				,@MonthlycommissionAmount decimal(18,4), @commissionCountedMonth int
		--				,@achivedcommitionMonthCount int, @ReferalEndDate datetime

		--		Declare cur_referalUser cursor for
		--	    select u.Id,r.GiverPhone, r.StartDate, r.MTD_Commission,r.EndDate  from ReferralAccount r inner join UserProfile u 
		--		on r.GetterPhone = u.Phone
		--		where CONVERT(VARCHAR(26), r.EndDate, 23) >= CONVERT(VARCHAR(26), DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)), 23) 
		--		and r.GetterPhone=@PhoneNo	
					
		--		--where MONTH( r.CreatedDate) <= @commissionMonth and YEAR(r.CreatedDate) <= @commissionYear  and r.GetterPhone=@PhoneNo		
					
		--			open cur_referalUser
		--			FETCH NEXT FROM cur_referalUser INTO @GiverUserId, @GiverPhone, @ReferalUserBillPayDate, @packageamount,@ReferalEndDate
		--			WHILE @@FETCH_STATUS =0
		--			BEGIN									

		--			--- core login here----
		--			--select @ReferalUserBillPayDate=b.CreateDate,@packageamount = b.MTD_Commission,@SubscriptionType = b.SubscriptionType,@ReferalEndDate=b.ReferralEndDate from BillingPayment b where b.UserPhone=@GiverPhone
					
		--			-- DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)) LastDayPreviousMonthWithTimeStamp
		--			if CONVERT(VARCHAR(26), @ReferalUserBillPayDate, 23) <= CONVERT(VARCHAR(26), DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)), 23) 
		--			 --MONTH(@ReferalUserBillPayDate) <= @commissionMonth
																																																																	
		--			begin
					
		--			-- now get subscriptiontype, subscriptionamount	
								
		--			--if @SubscriptionType = ''Basic''
		--			--	begin
		--			--		select @packageamount=MonthlyCosts from UserPricing where Id=1
		--			--	end
		--			--else if(@SubscriptionType = ''Silver'')
		--			--	begin
		--			--		select @packageamount=MonthlyCosts from UserPricing where Id=2
		--			--	end
		--			--else
		--			--	begin
		--			--		select @packageamount=MonthlyCosts from UserPricing where Id=3
		--			--	end		

		--				set @MonthlycommissionAmount = @packageamount		

		--				--set @MonthlycommissionAmount = (@packageamount*0.05)/12
		--				-- now check did getter phone user have this amount from commission month
		--				-- commission will be count for this user (currentmonth-1) - @ReferalUserBillPayDate
					
		--				set @commissionCountedMonth = (MONTH(GETDATE()) - MONTH(@ReferalUserBillPayDate))+1-- May - February = February,March,April
		--				--select @achivedcommitionMonthCount = COUNT(id) from ReferralTransaction where GetterPhone=@PhoneNo and GiverPhone=@GiverPhone
					
		--				DECLARE @count INT,@ReferalUserBillPayDateMonthCount int;
		--				SET @count = 1;
		--				set @ReferalUserBillPayDateMonthCount = MONTH(@ReferalUserBillPayDate);--@ReferalEndDate
		--				while @count <= @commissionCountedMonth 
		--					begin
		--					-- check is it the last month and year for the referal user 
		--					if ((@commissionMonth = MONTH(@ReferalEndDate) and @commissionYear =year(@ReferalEndDate)) OR @ReferalEndDate IS NULL)
		--						begin
		--							set @count =@count +1;
		--							set  @ReferalUserBillPayDateMonthCount =  @ReferalUserBillPayDateMonthCount +1;
		--						end
		--					else
		--						begin
		--							if not EXISTS (select id from ReferralTransaction r where CommissionFor=''User'' and GetterPhone=@PhoneNo and GiverPhone=@GiverPhone and r.Month = DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1) and @commissionYear=YEAR(@ReferalUserBillPayDate) )
		--								begin
		--									INSERT INTO [dbo].[ReferralTransaction]
		--							   ([GiverPhone]
		--							   ,[GetterPhone]
		--							   ,[TransactionDate]
		--							   ,[PayorAmount]
		--							   ,[Month]
		--							   ,[Year]
		--							   ,[Remarks]
		--							   ,[CreatedDate]
		--							   ,[CommissionMonthDate]
		--							   ,IsPaid
		--								,CommissionFor)
		--								select @GiverPhone,@PhoneNo,getdate(),@MonthlycommissionAmount,DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1),YEAR(GETDATE()),''commission added'',GETDATE(),DATEADD(month, -1, getdate()),0,''User''

		--									--- NOW update part
						
		--								end
		--								set @count =@count +1;
		--								set  @ReferalUserBillPayDateMonthCount =  @ReferalUserBillPayDateMonthCount +1;

		--						end
		--					end -- while end
		--				-- Update total referal count to billing table
		--				declare @TotalReferalCount int,@YTDcommissionOwed decimal(18,4)

		--				--set @TotalReferalCount =(select COUNT(distinct GiverPhone) from ReferralTransaction where GetterPhone=@PhoneNo)
					
		--				--update BillingPayment set Total_ReferralUser=@TotalReferalCount where UserPhone=@PhoneNo

		--				set @YTDcommissionOwed =(select isnull(sum(PayorAmount),0) from ReferralTransaction where CommissionFor=''User'' and GetterPhone=@PhoneNo and GiverPhone=@GiverPhone)
					
		--				update ReferralAccount set YTD_CommissionOwed=@YTDcommissionOwed,  MTD_CommissionOwed = @packageamount, LastTransactionDate = GETDATE()  where GetterPhone=@PhoneNo and GiverPhone=@GiverPhone


		--			end

		--			--FETCH NEXT FROM cur_referalUser INTO @GiverUserId, @GiverPhone		
		--			FETCH NEXT FROM cur_referalUser INTO @GiverUserId, @GiverPhone, @ReferalUserBillPayDate, @packageamount,@ReferalEndDate
		--			END
		--			CLOSE cur_referalUser
		--			DEALLOCATE cur_referalUser


		--			FETCH NEXT FROM cur_commission INTO @userId,@PhoneNo 
			
		--			END
		--			CLOSE cur_commission
		--			DEALLOCATE cur_commission


		--COMMIT TRAN
		--END TRY
		--BEGIN CATCH
		--	ROLLBACK TRAN
		--END CATCH

	end

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetCommissionAmount_All_DateWise]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetCommissionAmount_All_DateWise]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[usp_GetCommissionAmount_All_DateWise] @StartDate varchar(50),@EndDate varchar(50),@GetterPhoneNo varchar(20), @commissionFor varchar(20)
-- exec usp_GetCommissionAmount_All_DateWise ''2020-01-01'',''2020-02-01'',''8801817708660'',''User''
-- exec usp_GetCommissionAmount_All_DateWise ''NULL'',''NULL'',''8801817708660'',''User''
as
begin
	declare @Startd datetime,@Endd datetime
	if @StartDate = ''NULL'' 
		begin
			set @Startd=null;
		end
	else
		begin
			set @Startd = convert(datetime, @StartDate);
			--set @Startd = cast(@StartDate as datetime);
		end
	if @EndDate = ''NULL'' 
		begin
			set @Endd=null;
		end
	else
		begin
			set @Endd = convert(datetime, @EndDate);
			--set @Endd = cast(@EndDate as datetime);
		end

	select u.FirstName + '' '' + u.LastName as Name,r.GiverPhone PhoneNo,CONVERT(date, u.CreatedDate) RegistrationDate,r.Month, r.Year, isnull(r.PayorAmount,0) ReferalCommissionAmount,(case when r.IsPaid = 1 then ''Paid'' else ''Not Paid'' end) Status 
	from ReferralTransaction r
	--inner join ContactInformation c on r.GiverPhone = c.Phone
	inner join UserProfile u on r.GiverPhone = u.Phone
	 where r.GetterPhone=@GetterPhoneNo 
	--and (((MONTH(r.CommissionMonthDate) BETWEEN MONTH(@Startd) AND MONTH(@Endd))
	--AND (YEAR(r.CommissionMonthDate)  BETWEEN YEAR(@Startd) AND YEAR(@Endd))) or (@Startd is null and @Endd is null))
	and r.CommissionFor= @commissionFor
	and ((CONVERT(VARCHAR(26), r.CommissionMonthDate, 23)  between @Startd and @Endd) or (@Startd is null and @Endd is null))

end


' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetCommissionByUserType]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetCommissionByUserType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[usp_GetCommissionByUserType] @phoneNo varchar(20), @commissionFor varchar(20) 
-- exec usp_GetCommissionByUserType ''8801817708660'', ''Dealer''
as
begin

	declare @CommissionOwned decimal(18,2)

	set @CommissionOwned =(select sum(PayorAmount) as CommissionOwned from ReferralTransaction where GetterPhone=@phoneNo and CommissionFor=@commissionFor and IsPaid = 0)
	
	Select Month, Year, isnull(sum(PayorAmount),0) amount, IsPaid, ISNULL(@CommissionOwned,0.000) CommissionOwned 
	
	from ReferralTransaction 

	where GetterPhone=@phoneNo and CommissionFor=@commissionFor and IsPaid = 0

	group by Year,Month,IsPaid 

	order by DATEPART(MM,Month + '' 01 '' + Year) desc

end



' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetCommissionDetailsByUserType]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetCommissionDetailsByUserType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE proc [dbo].[usp_GetCommissionDetailsByUserType] @commissionFor varchar(20), @Month varchar(10), @Year int, @Ispaid bit, @phoneNo varchar(20)
-- exec usp_GetCommissionDetailsByUserType ''Dealer'',''March'',2020,0,''8801816027706''
as
begin

	 select c.FirstName + '' '' + c.LastName as Name, c.City,c.Zip,isnull(r.PayorAmount,0) Amount, c.Phone, C.Address, C.State

	 from ReferralTransaction r inner join UserProfile c on r.GiverPhone=c.Phone and r.GetterPhone=@phoneNo

	 where Month=@Month and Year=@Year and r.IsPaid=@Ispaid and r.CommissionFor=@commissionFor

end



' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetCommissionDetailsForDealer]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetCommissionDetailsForDealer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE proc [dbo].[usp_GetCommissionDetailsForDealer] @Month varchar(10), @Year int,@Ispaid bit, @Id int
-- exec usp_GetCommissionDetailsForDealer ''February'',2020,0, 1
as
begin

--select c.FirstName + '' '' + c.LastName as Name, c.City,c.Zip,isnull(r.PayorAmount,0) Amount
-- from ReferralTransaction r inner join UserProfile c on r.GiverPhone=c.Phone 
-- where Month=@Month and Year=@Year and r.IsPaid=@Ispaid and r.CommissionFor=''Dealer''

declare @phoneNo varchar(20)

select @phoneNo =u.Phone from UserProfile u  inner join Dealer_SalesPartner d on u.phone=d.primaryPhoneNo and d.Id=@Id
	select c.FirstName + '' '' + c.LastName as Name, c.City,c.Zip,isnull(r.PayorAmount,0) Amount, c.Phone, C.Address, C.State
 from ReferralTransaction r inner join UserProfile c on r.GiverPhone=c.Phone and r.GetterPhone=@phoneNo
 where r.Month=@Month and r.Year=@Year and r.IsPaid=@Ispaid and r.CommissionFor=''Dealer'' 

end



' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetCommissionForDealerChange]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetCommissionForDealerChange]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE proc [dbo].[usp_GetCommissionForDealerChange] @Id int
-- exec usp_GetCommissionForDealerChange 1
as
begin

	declare @phoneNo varchar(20),@CommissionOwned decimal(18,3)

	--select @phoneNo =u.Phone from UserProfile u  inner join Dealer_SalesPartner d on u.Serial=d.serialCode where d.Id=@Id and u.UserTypeContact=3

	select @phoneNo =u.Phone from UserProfile u  inner join Dealer_SalesPartner d on u.phone=d.primaryPhoneNo where d.Id=@Id

	set @CommissionOwned =(select sum(PayorAmount) as CommissionOwned from ReferralTransaction where GetterPhone=@phoneNo and CommissionFor=''Dealer'' and IsPaid = 0)
	

	select Month, Year, isnull(sum(PayorAmount),0) amount, IsPaid, ISNULL(@CommissionOwned,0.000) CommissionOwned 
	
	from ReferralTransaction 

	where GetterPhone=@phoneNo and CommissionFor=''Dealer'' --and IsPaid=0

	group by Year,Month,IsPaid 

	order by DATEPART(MM,Month + '' 01 '' + Year) desc

end




' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getContactStorageBalance]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_getContactStorageBalance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE proc [dbo].[usp_getContactStorageBalance] @UserId int
-- exec usp_getContactStorageBalance 1
as
	begin
		declare @StorageLimit int, @TotalContact int, @TotalImportLimit int

		set @StorageLimit =(select ISNULL(Contact_Storage_Limit,0) Contact_Storage_Limit from UserProfile  where Id=@UserId)
		
		set @TotalContact =(select ISNULL(count(Id),0) Total from ContactInformation  where UserId=@UserId)
		
		set @TotalImportLimit = case when @StorageLimit > 0 then isnull(@StorageLimit,0) - isnull(@TotalContact,0) else 0 end
		
		select @TotalImportLimit

	end


' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getCurrentMonthContactImport]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_getCurrentMonthContactImport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[usp_getCurrentMonthContactImport] @UserId int
-- exec usp_getCurrentMonthContactImport 1
as
begin
declare @TotalImportInCurrentMonth int
set @TotalImportInCurrentMonth =(
select ISNULL(sum(i.NoOfImport),0) TotalImportInCurrentMonth from ImportContact i where i.UserId=@UserId and MONTH(i.TranDate) = MONTH(GETDATE()) 
and YEAR(GETDATE()) = YEAR(i.TranDate) and i.IsImport=1)
select @TotalImportInCurrentMonth TotalImportInCurrentMonth
end

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getCurrentYearContactExport]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_getCurrentYearContactExport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[usp_getCurrentYearContactExport] @UserId int
-- exec usp_getCurrentYearContactExport 1
as
begin
declare @TotalExportInCurrentYear int
set @TotalExportInCurrentYear =(
select ISNULL(sum(i.NoOfExport),0) TotalExportInCurrentYear from ImportContact i where i.UserId=@UserId and YEAR(GETDATE()) = YEAR(i.TranDate) and i.IsExport=1)
select @TotalExportInCurrentYear TotalExportInCurrentYear
end

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetDelarInfoByPhoneNo]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetDelarInfoByPhoneNo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE proc [dbo].[usp_GetDelarInfoByPhoneNo] @PhoneNo varchar(20)
-- exec usp_GetDelarInfoByPhoneNo ''2156691499''

as
begin

declare @UserTYpe int, @Admin int

	set @UserTYpe =(select cast(u.UserTypeContact as int) from UserProfile u where u.Phone = @PhoneNo)
	set @Admin =(select cast(u.IsAdmin as int) from UserProfile u where u.Phone = @PhoneNo)

	if @UserTYpe =1 or @Admin =1
		begin
			select d.id DealerID ,isnull(d.firstName,'''') firstName,isnull(d.lastName,'''') lastName,isnull(d.address1,'''') address1
			,isnull(d.address2,'''') address2,isnull(d.city,'''') city,isnull(d.stateId,'''') stateId,isnull(s.STATENAME,'''') STATENAME
			,isnull(d.zipCode,'''') zipCode,isnull(d.mobilePhoneNo,'''') mobilePhoneNo,isnull(d.email,'''') email,isnull(d.serialCode,'''') serialCode
			,isnull(d.joinDate,'''') joinDate,isnull(d.commissionRate,''0'') commissionRate,isnull(d.primaryPhoneNo,'''') primaryPhoneNo
			,isnull(d.accountNo,'''') accountNo,isnull(d.routingNo,'''') routingNo,isnull(u.Password,'''') Password
		
			from Dealer_SalesPartner d 
			inner join States s on s.STATE=d.stateId
			left join UserProfile u on u.Phone=d.mobilePhoneNo
			where cast(d.userType as int)=3 

		end
	else if @UserTYpe=3
		begin
			select d.id DealerID ,isnull(d.firstName,'''') firstName,isnull(d.lastName,'''') lastName,isnull(d.address1,'''') address1
			,isnull(d.address2,'''') address2,isnull(d.city,'''') city,isnull(d.stateId,'''') stateId,isnull(s.STATENAME,'''') STATENAME
			,isnull(d.zipCode,'''') zipCode,isnull(d.mobilePhoneNo,'''') mobilePhoneNo,isnull(d.email,'''') email,isnull(d.serialCode,'''') serialCode
			,isnull(d.joinDate,'''') joinDate,isnull(d.commissionRate,''0'') commissionRate,isnull(d.primaryPhoneNo,'''') primaryPhoneNo
			,isnull(d.accountNo,'''') accountNo,isnull(d.routingNo,'''') routingNo,isnull(u.Password,'''') Password 

			from Dealer_SalesPartner d 
			inner join States s on s.STATE=d.stateId
			left join UserProfile u on u.Phone=d.mobilePhoneNo
			where d.mobilePhoneNo=@PhoneNo 

		end

--declare @UserTYpe int
--set @UserTYpe =(select cast(u.UserTypeContact as int) from UserProfile u where right(u.Phone, 10) = right(@PhoneNo, 10))

--if @UserTYpe =1
--begin
--select d.id DealerID ,isnull(d.firstName,'''') firstName,isnull(d.lastName,'''') lastName,isnull(d.address1,'''') address1,isnull(d.address2,'''') address2,isnull(d.city,'''') city,isnull(d.stateId,'''') stateId,isnull(s.STATENAME,'''') STATENAME,isnull(d.zipCode,'''') zipCode,isnull(d.mobilePhoneNo,'''') mobilePhoneNo,isnull(d.email,'''') email,isnull(d.serialCode,'''') serialCode,isnull(d.joinDate,'''') joinDate,isnull(d.commissionRate,''0'') commissionRate,isnull(d.primaryPhoneNo,'''') primaryPhoneNo,isnull(d.accountNo,'''') accountNo,isnull(d.routingNo,'''') routingNo,isnull(u.Password,'''') Password
--from Dealer_SalesPartner d 
--inner join States s on s.STATE=d.stateId
--left join UserProfile u on u.Phone=d.mobilePhoneNo
--where cast(d.userType as int)=3 

--end
--else if @UserTYpe=3
--begin
--select d.id DealerID ,isnull(d.firstName,'''') firstName,isnull(d.lastName,'''') lastName,isnull(d.address1,'''') address1,isnull(d.address2,'''') address2,isnull(d.city,'''') city,isnull(d.stateId,'''') stateId,isnull(s.STATENAME,'''') STATENAME,isnull(d.zipCode,'''') zipCode,isnull(d.mobilePhoneNo,'''') mobilePhoneNo,isnull(d.email,'''') email,isnull(d.serialCode,'''') serialCode,isnull(d.joinDate,'''') joinDate,isnull(d.commissionRate,''0'') commissionRate,isnull(d.primaryPhoneNo,'''') primaryPhoneNo,isnull(d.accountNo,'''') accountNo,isnull(d.routingNo,'''') routingNo,isnull(u.Password,'''') Password 
--from Dealer_SalesPartner d 
--inner join States s on s.STATE=d.stateId
--left join UserProfile u on u.Phone=d.mobilePhoneNo
--where d.mobilePhoneNo=@PhoneNo 
--end


end



' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetDueCommissionByUser]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetDueCommissionByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE proc [dbo].[usp_GetDueCommissionByUser] @phoneNo varchar(20), @commissionFor varchar(20) 
-- exec usp_GetDueCommissionByUser ''8801816027706'', ''Dealer''
as
begin

	declare @CommissionOwed decimal(18,2)

	set @CommissionOwed =(select sum(PayorAmount) as CommissionOwned from ReferralTransaction where GetterPhone=@phoneNo and CommissionFor=@commissionFor and IsPaid = 0)
	
	Select Year, Month, GiverPhone, isnull(PayorAmount,0) Amount, (case when IsPaid = 1 then ''Paid'' else ''Not Paid'' end) Status, ISNULL(@CommissionOwed,0.000) CommissionOwed 
	
	from ReferralTransaction 

	where GetterPhone=@phoneNo and CommissionFor=@commissionFor and IsPaid = 0	

	order by DATEPART(MM,Month + '' 01 '' + Year) asc

end




' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetGroupCodeByUserType]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetGroupCodeByUserType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE proc [dbo].[usp_GetGroupCodeByUserType] @GroupCodeFor varchar(30), @PhoneNo varchar(20)
-- exec usp_GetGroupCodeByUserType ''User'', ''01817708660''

as
begin

declare @UserTYpe int

--set @UserTYpe =(select cast(u.UserTypeContact as int) from UserProfile u where right(u.Phone, 10) = right(@PhoneNo, 10))

set @UserTYpe =(select cast(u.IsAdmin as int) from UserProfile u where right(u.Phone, 10) = right(@PhoneNo, 10))

if @UserTYpe =1
	begin

	select Id, isnull(BillEvery,'''') BillEvery,isnull(GroupCodeNo,'''') GroupCodeNo, isnull(GroupName,'''') GroupName, isnull(GroupDescription,'''') GroupDescription

	from GroupCode 

	where GroupCodeFor = @GroupCodeFor and DeletedBy is null

	end

else 

	begin

	select Id, isnull(BillEvery,'''') BillEvery,isnull(GroupCodeNo,'''') GroupCodeNo, isnull(GroupName,'''') GroupName, isnull(GroupDescription,'''') GroupDescription

	from GroupCode 

	where GroupCodeFor = @GroupCodeFor and DeletedBy is null 
	and right(CreditPhoneNo, 10) = right(@PhoneNo, 10) 

	end

end




' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getPhoneNoByAutoComplete]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_getPhoneNoByAutoComplete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[usp_getPhoneNoByAutoComplete] @autocompleteText varchar(20), @GroupCodeFor varchar(10)
as
begin
if(@GroupCodeFor =''Dealer'')
begin
select (Isnull(Phone,'''') + '' - '' + Isnull(FirstName,'''') + '' '' +  Isnull(LastName,'''')) label, id  from UserProfile u where u.[UserTypeContact] = 3 and Phone like ''%''+@autocompleteText+''%''
end
else
begin
select (Isnull(Phone,'''') + '' - '' + Isnull(FirstName,'''') + '' '' +  Isnull(LastName,'''')) label,id   from UserProfile u where u.[UserTypeContact] <> 3 and Phone like ''%''+@autocompleteText+''%''
end
end


' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserInfoByDealer]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUserInfoByDealer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE proc [dbo].[usp_GetUserInfoByDealer] @phoneNo varchar(20)
-- exec usp_GetUserInfoByDealer ''8801816027706''

as
begin

	select isnull(c.FirstName,'''') + '' '' + isnull(c.LastName,'''') as Name, isnull(c.Phone,'''') Phone, isnull(c.Address,'''') Address, isnull(c.City,'''') City, isnull(C.State,'''') State, isnull(c.Zip,'''') Zip, c.CreatedDate
	from UserProfile c where c.UserTypeContact = ''2'' and  c.Zip in (
	select z.zipCode from UserProfile u inner join Dealer_SalesPartner_DetailsZipCodeCoverage z 
	on z.dealerSalesPartnerId=u.Serial and u.Phone = @phoneNo
	)

end




' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ImportToContact]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ImportToContact]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROC [dbo].[usp_ImportToContact] @ContactInformation tblContactInfo READONLY,
 @createdBy varchar(20),@TypeOfContact varchar(3),@balance varchar(30),@Mass VARCHAR(200) OUTPUT,@error VARCHAR(max) OUTPUT
 as
 BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
BEGIN TRANSACTION
BEGIN TRY 


	DECLARE @FirstName varchar(50) ,@MiddleName varchar(50) ,@LastName varchar(50) ,@Email varchar(100) ,
	@Address nvarchar(150) ,@Address1 nvarchar(150) ,@Region varchar(50) ,@Country varchar(50) ,
	@State varchar(30) ,@City varchar(30) ,@Zip varchar(10) ,@Phone varchar(30) ,
	@WorkPhone varchar(30) ,@WorkPhoneExt varchar(30) ,@Fax varchar(30) ,@IsActive bit ,
	@Website varchar(100) ,@Category varchar(30) ,@TypeContact varchar(300), @IsEmailFlow smallint,
	@tblCreatedBy varchar(30) ,@CreatedDate datetime ,	@RefPhone varchar(30),@CompanyName varchar(100) ,@Title varchar(100) ,@NewID int ,@i int=0,@U int=0, @balanceLimit bigint=0

	if @balance =''unlimited'' set @balanceLimit=1000000 else set @balanceLimit=CONVERT(int, @balance)

	declare @UserId int		
		set @UserId =(select top 1 Id from UserProfile where Phone = @createdBy)

		DECLARE db_contact CURSOR FOR
		SELECT 			
		    c.FirstName,c.MiddleName,c.LastName,c.Email,c.Address,c.Address1,c.Region,c.Country,c.State,c.City,c.Zip,c.Phone,
			c.WorkPhone,c.WorkPhoneExt,c.Fax,c.IsActive,@createdBy,@CreatedDate,c.RefPhone,c.Title,c.CompanyName,c.Category,c.TypeOfContact,c.IsEmailFlow, c.Website
			FROM @ContactInformation c
			
			OPEN db_contact 
			
			FETCH NEXT FROM db_contact INTO 
				@FirstName ,@MiddleName ,@LastName ,@Email ,@Address ,@Address1 ,@Region ,@Country,
				@State ,@City ,@Zip ,@Phone ,@WorkPhone ,@WorkPhoneExt,@Fax ,@IsActive,
				@tblCreatedBy ,@CreatedDate ,@RefPhone ,@Title,@CompanyName,@Category,@TypeContact, @IsEmailFlow, @Website  		
			
			WHILE @@FETCH_STATUS =0
			BEGIN			
			
			--- Update Contact Info ----
			if exists (select * from ContactInformation where Phone = @Phone and UserId = @UserId)
				begin
					UPDATE [dbo].[ContactInformation]
					SET 
						 [FirstName] = @FirstName
						,[MiddleName] = @MiddleName
						,[LastName] = @LastName
						,[Email] = @Email
						,[Address] = @Address
						,[Address1] = @Address1
						,[Region] = @Region
						,[Country] = @Country
						,[State] = @State
						,[City] =@City
						,[Zip] = @Zip
						,[Phone] = @Phone
						,[WorkPhone] = @WorkPhone
						,[WorkPhoneExt] = @WorkPhoneExt
						,[Fax] = @Fax     
						,[IsActive] = @IsActive
						,[UserTypeContact] = @TypeOfContact    
						,[UpdatedBy] = @createdBy
						,[UpdatedDate] = GETDATE()
						,[RefPhone] =@RefPhone
						,[Title] = @Title
						,[TypeOfContact] = @TypeContact
						,[CompanyName] = @CompanyName
						,[Category] = @Category
						,[IsEmailFlow] = @IsEmailFlow
						,[Website] = @Website

					WHERE Phone = @Phone and UserId=@UserId
						set @U = @U+1;
				end
			else
			begin
				if @i <@balanceLimit
					begin
					  -- Insert into Contact Info
						INSERT INTO [dbo].[ContactInformation]
					   ([UserId]
					   ,[FirstName]
					   ,[MiddleName]
					   ,[LastName]
					   ,[Email]
					   ,[Address]
					   ,[Address1]
					   ,[Region]
					   ,[Country]
					   ,[State]
					   ,[City]
					   ,[Zip]
					   ,[Phone]
					   ,[WorkPhone]
					   ,[WorkPhoneExt]
					   ,[Fax]
					   ,[IsActive]
					   ,[UserTypeContact]
					   ,[CreatedBy]
					   ,[CreatedDate]
					   ,[RefPhone]
					   ,[Title]
					   ,[TypeOfContact]
					   ,[CompanyName]
					   ,[Category]
					   ,[IsEmailFlow]
					   ,[Website])
					   select @UserId,@FirstName,@MiddleName,@LastName,@Email,@Address,@Address1,@Region,@Country,@State,@City,@Zip,@Phone,
					   @WorkPhone,@WorkPhoneExt,@Fax,@IsActive,@TypeOfContact,@createdBy,GETDATE(),@RefPhone,@Title,@TypeContact,@CompanyName,@Category,@IsEmailFlow,@Website
		 
					end
					set @i= @i +1;
				end
			
			
			FETCH NEXT FROM db_contact INTO 
				@FirstName ,@MiddleName ,@LastName ,@Email ,@Address ,@Address1 ,@Region ,@Country,
				@State ,@City ,@Zip ,@Phone ,@WorkPhone ,@WorkPhoneExt,@Fax,@IsActive,
				@tblCreatedBy ,@CreatedDate ,@RefPhone ,@Title,@CompanyName,@Category,@TypeContact, @IsEmailFlow, @Website   
			
			END
			CLOSE db_contact
			DEALLOCATE db_contact
		

			INSERT INTO [dbo].[ImportContact]
			   ([UserId]
			   ,[IsImport]
			   ,[IsExport]
			   ,[NoOfImport]
			   ,[NoOfExport]
			   ,[TranDate]
			   ,[CreatedBy]
			   ,[CreatedDate])
			   values(@UserId,1,0,@i,0,GETDATE(),@createdBy,GETDATE())


			declare @totalcontactMonthly int,@totalcontactYearly int
			set @totalcontactMonthly =( select ISNULL(sum(i.NoOfImport),0) TotalImportInCurrentMonth from ImportContact i 
			where i.UserId=@UserId and MONTH(i.TranDate) = MONTH(GETDATE()) 
			and YEAR(GETDATE()) = YEAR(i.TranDate) and i.IsImport=1)

			update UserProfile set MTD_Contact_Import =@totalcontactMonthly, LastImportedDate = getdate() where Id=@UserId

		--SET @Mass = ''Number of inserted contact : ''+@i + '' '' + '' Updated contact: '' + @U;
		
		SET @Mass = ''Number of Inserted contact : ''+ CAST(@i as varchar(20)) + '' . '' + '' Updated contact: '' + CAST(@U as varchar(20));

		 END TRY  
		
		BEGIN CATCH    
		SET @error = ERROR_MESSAGE();

			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  

		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION; 
		 END







' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateUserProfileEmailAndPassword]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UpdateUserProfileEmailAndPassword]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[usp_UpdateUserProfileEmailAndPassword] @Password varchar(max), @Email varchar(30), @MobileNo varchar(30)
as
begin
update UserProfile set Password=@Password, Email=@Email,UpdatedBy=@MobileNo,UpdatedDate=GETDATE() where Username=@MobileNo
end

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateUserProfileForExportData]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UpdateUserProfileForExportData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[usp_UpdateUserProfileForExportData] @createdBy varchar(30),@NoOfExport int
as
begin
declare @UserId int

		set @UserId =(select top 1 Id from UserProfile where Phone = @createdBy)


			INSERT INTO [dbo].[ImportContact]
           ([UserId]
           ,[IsImport]
           ,[IsExport]
           ,[NoOfImport]
           ,[NoOfExport]
           ,[TranDate]
           ,[CreatedBy]
           ,[CreatedDate])
		   values(@UserId,0,1,0,@NoOfExport,GETDATE(),@createdBy,GETDATE())


			declare @totalcontactMonthly int,@totalcontactYearly int

			set @totalcontactYearly =( select ISNULL(sum(i.NoOfExport),0) TotalExportInCurrentMonth from ImportContact i 
			where i.UserId=@UserId  
			and YEAR(GETDATE()) = YEAR(i.TranDate) and i.IsExport=1)

			update UserProfile set YTD_Contact_Export = @totalcontactYearly, LastExportedDate = getdate() where Id=@UserId

			
end

' 
END
GO
/****** Object:  Table [dbo].[BillingPayment]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BillingPayment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BillingPayment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](20) NULL,
	[UserPhone] [varchar](30) NULL,
	[SubscriptionType] [varchar](15) NULL,
	[IsStorageSubscription] [bit] NULL,
	[IsReceivedCommissions] [bit] NULL,
	[SubscriptionExpiredOn] [datetime] NULL,
	[StorageExpiredOn] [datetime] NULL,
	[YTD_Contact_Export_Limit] [varchar](10) NULL,
	[MTD_Contact_Import_Limit] [varchar](10) NULL,
	[Contact_Storage_Limit] [varchar](10) NULL,
	[IsBillingCycleMonthly] [bit] NULL,
	[IsBillingComplete] [bit] NULL,
	[ReferralStartDate] [datetime] NULL,
	[ReferralEndDate] [datetime] NULL,
	[IsCommissionMonthly] [bit] NULL,
	[YTD_Commission] [varchar](20) NULL,
	[MTD_Commission] [varchar](20) NULL,
	[CreateDate] [datetime] NULL,
	[Status] [varchar](20) NULL,
	[Remarks] [varchar](20) NULL,
	[YTD_ReferralUser] [varchar](20) NULL,
	[Total_ReferralUser] [varchar](20) NULL,
	[ReferralRecycleDate] [datetime] NULL,
	[LastReferralCalculatedDate] [datetime] NULL,
	[IsRecurring] [bit] NULL,
	[BasicAmount] [varchar](20) NULL,
	[StorageAmount] [varchar](20) NULL,
	[SubTotalCharge] [varchar](20) NULL,
	[Promocode] [varchar](100) NULL,
	[DiscountPercentage] [varchar](20) NULL,
	[Discount] [varchar](20) NULL,
	[GrossAmount] [varchar](20) NULL,
	[CheckingAccountProcessingFee] [varchar](20) NULL,
	[NetAmount] [varchar](20) NULL,
	[NoOfContact] [varchar](20) NULL,
	[ContactMultiplier] [varchar](20) NULL,
	[TotalContact] [varchar](20) NULL,
	[PerUnitCharge] [varchar](20) NULL,
	[MonthlyCharge] [varchar](20) NULL,
	[IsAgree] [bit] NULL,
 CONSTRAINT [PK_BillingPayment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CalendarEntry]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CalendarEntry]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CalendarEntry](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](100) NULL,
	[UserEmail] [varchar](100) NULL,
	[UserId] [varchar](20) NULL,
	[UserCode] [varchar](20) NULL,
	[Timezone] [varchar](20) NULL,
	[MeetingDate] [date] NULL,
	[GMTTimeStart] [datetime] NULL,
	[MeetingStartTime] [varchar](100) NULL,
	[GMTTimeEnd] [datetime] NULL,
	[MeetingEndTime] [varchar](100) NULL,
	[Duration] [int] NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](20) NULL,
	[UpdatedDate] [datetime] NULL,
	[TimeZoneDifference] [int] NULL,
	[IsAvailable] [tinyint] NULL,
	[MeetingStartTimeShow] [varchar](100) NULL,
 CONSTRAINT [PK_CalendarEntry] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CalendarSchedule]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CalendarSchedule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CalendarSchedule](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[MeetingId] [bigint] NULL,
	[UserName] [varchar](100) NULL,
	[UserEmail] [varchar](100) NULL,
	[UserId] [varchar](20) NULL,
	[ToUserFirstName] [varchar](100) NULL,
	[ToUserLastName] [varchar](100) NULL,
	[ToUserEmail] [varchar](100) NULL,
	[ToUserPhone] [varchar](30) NULL,
	[ToUserCompany] [varchar](100) NULL,
	[Notes] [nvarchar](200) NULL,
	[Timezone] [varchar](20) NULL,
	[TimeZoneDifference] [int] NULL,
	[MeetingDate] [date] NULL,
	[GMTTimeStart] [datetime] NULL,
	[MeetingStartTime] [varchar](100) NULL,
	[GMTTimeEnd] [datetime] NULL,
	[MeetingEndTime] [varchar](100) NULL,
	[Duration] [int] NULL,
	[IsBooked] [tinyint] NULL,
	[IsSentEmail] [tinyint] NULL,
	[MeetingStartTimeShow] [varchar](100) NULL,
 CONSTRAINT [PK_CalendarSchedule] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Child]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Child]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Child](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentId] [int] NOT NULL,
	[UserDefinedId] [int] NOT NULL,
	[Code] [nvarchar](300) NULL,
	[Description] [nvarchar](300) NULL,
	[CompanyId] [int] NULL,
	[CreatedBy] [smallint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [smallint] NULL,
	[UpdatedDate] [datetime] NULL,
	[OwnerId] [nvarchar](20) NULL,
 CONSTRAINT [PK_dbo.Child] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ContactInformation]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactInformation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ContactInformation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[Address] [nvarchar](150) NULL,
	[Address1] [nvarchar](150) NULL,
	[Region] [varchar](50) NULL,
	[Country] [varchar](30) NULL,
	[State] [varchar](20) NULL,
	[City] [varchar](30) NULL,
	[Zip] [varchar](10) NULL,
	[Phone] [varchar](30) NULL,
	[WorkPhone] [varchar](30) NULL,
	[WorkPhoneExt] [varchar](30) NULL,
	[Fax] [varchar](30) NULL,
	[Website] [varchar](100) NULL,
	[Category] [varchar](50) NULL,
	[ProfileLogo] [varchar](300) NULL,
	[CompanyName] [varchar](100) NULL,
	[IsOverwrite] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsActive] [bit] NULL,
	[UserTypeContact] [varchar](30) NULL,
	[Other] [varchar](300) NULL,
	[CreatedBy] [varchar](30) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](30) NULL,
	[UpdatedDate] [datetime] NULL,
	[RefPhone] [varchar](30) NULL,
	[Title] [varchar](100) NULL,
	[TypeOfContact] [varchar](300) NULL,
	[Memo] [varchar](250) NULL,
	[CountryCode] [varchar](5) NULL,
	[Longitude] [varchar](30) NULL,
	[Latitude] [varchar](30) NULL,
	[IsEmailFlow] [smallint] NULL,
 CONSTRAINT [PK_ContactInformation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Country]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Country](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[iso] [char](2) NULL,
	[name] [nvarchar](80) NULL,
	[nicename] [nvarchar](80) NULL,
	[iso3] [char](3) NULL,
	[numcode] [smallint] NULL,
	[phonecode] [int] NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Dealer_SalesPartner]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dealer_SalesPartner]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Dealer_SalesPartner](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[serialCode] [varchar](20) NULL,
	[firstName] [varchar](50) NULL,
	[lastName] [varchar](50) NULL,
	[address1] [varchar](100) NULL,
	[address2] [varchar](100) NULL,
	[city] [varchar](30) NULL,
	[stateId] [varchar](20) NULL,
	[countryId] [varchar](20) NULL,
	[region] [varchar](30) NULL,
	[zipCode] [varchar](30) NULL,
	[primaryPhoneNo] [varchar](20) NULL,
	[mobilePhoneNo] [varchar](20) NULL,
	[routingNo] [varchar](25) NULL,
	[accountNo] [varchar](25) NULL,
	[email] [varchar](50) NULL,
	[userType] [int] NULL,
	[joinDate] [datetime] NULL,
	[commissionRate] [decimal](10, 2) NULL,
	[createDate] [datetime] NULL,
 CONSTRAINT [PK_DealerSalesPartnerProfile] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Dealer_SalesPartner_DetailsZipCodeCoverage]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dealer_SalesPartner_DetailsZipCodeCoverage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Dealer_SalesPartner_DetailsZipCodeCoverage](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dealerSalesPartnerId] [varchar](20) NULL,
	[zipCode] [varchar](30) NULL,
	[commissionRate] [decimal](10, 2) NULL,
 CONSTRAINT [PK_Dealer_SalesPartner_DetailsZipCodeCoverage] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailLog]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmailLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmailLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PersonEmail] [varchar](50) NULL,
	[FromEmail] [varchar](50) NULL,
	[EmailNumber] [int] NULL,
	[EmailSentOn] [datetime] NULL,
	[Status] [varchar](10) NULL,
	[TemplateId] [varchar](10) NULL,
 CONSTRAINT [PK_EmailLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailSchedule]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmailSchedule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmailSchedule](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PersonName] [varchar](100) NULL,
	[PersonEmail] [varchar](50) NULL,
	[FromEmail] [varchar](50) NULL,
	[IsLoop] [bit] NULL,
	[Days] [varchar](3) NULL,
	[IsZeroMailSent] [bit] NULL,
	[ZeroEmailSentOn] [datetime] NULL,
	[LastEmailNumber] [int] NULL,
	[LastEmailSentOn] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](20) NULL,
	[UpdatedDate] [datetime] NULL,
	[Category] [varchar](30) NULL,
	[Type] [varchar](300) NULL,
 CONSTRAINT [PK_EmailSchedule] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailSetup]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmailSetup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmailSetup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](20) NULL,
	[TemplateNo] [varchar](3) NULL,
	[Category] [varchar](30) NULL,
	[Type] [varchar](300) NULL,
	[Subject] [varchar](300) NULL,
	[Content] [nvarchar](max) NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](20) NULL,
	[UpdatedDate] [datetime] NULL,
	[Greetings] [varchar](50) NULL,
 CONSTRAINT [PK_EmailSetup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailUnsubscribe]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmailUnsubscribe]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmailUnsubscribe](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TemplateNo] [varchar](5) NULL,
	[UserId] [varchar](15) NULL,
	[TemplateId] [varchar](10) NULL,
 CONSTRAINT [PK_EmailUnsubscribe] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FinancialTransaction]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FinancialTransaction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FinancialTransaction](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Serial] [varchar](20) NULL,
	[AccountType] [varchar](20) NULL,
	[LedgerCode] [varchar](20) NULL,
	[InvoiceNo] [varchar](20) NULL,
	[RefId] [varchar](20) NULL,
	[Amount] [money] NULL,
	[Debit] [money] NULL,
	[Credit] [money] NULL,
	[CreateDate] [datetime] NULL,
	[Remarks] [varchar](20) NULL,
	[EntryType] [varchar](10) NULL,
 CONSTRAINT [PK_FinancialTransaction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GlobalID]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GlobalID]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GlobalID](
	[ObjectID] [varchar](255) NOT NULL,
	[ItemID] [varchar](255) NOT NULL,
	[IDForYear] [int] NULL,
	[IDForMonth] [int] NULL,
	[IDForDate] [datetime] NULL,
	[CurrentID] [int] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GroupCode]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GroupCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GroupCode](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GroupCodeNo] [varchar](200) NULL,
	[GroupName] [varchar](200) NULL,
	[GroupDescription] [varchar](max) NULL,
	[GroupPlan] [varchar](15) NULL,
	[Amount] [decimal](18, 2) NULL,
	[BillEvery] [varchar](15) NULL,
	[IsForever] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[IsRequiredACHInfo] [bit] NULL,
	[CreditPhoneNo] [varchar](20) NULL,
	[Rewards] [decimal](18, 2) NULL,
	[GroupCodeFor] [varchar](20) NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](20) NULL,
	[UpdatedDate] [datetime] NULL,
	[DeletedBy] [varchar](20) NULL,
	[DeletedDate] [datetime] NULL,
 CONSTRAINT [PK_GroupCode] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ImportContact]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImportContact]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ImportContact](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[IsImport] [bit] NULL,
	[IsExport] [bit] NULL,
	[NoOfImport] [int] NULL,
	[NoOfExport] [int] NULL,
	[TranDate] [datetime] NULL,
	[CreatedBy] [varchar](30) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ImportContact] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Master]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Master]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Master](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserDefinedId] [int] NOT NULL,
	[Code] [nvarchar](20) NULL,
	[Description] [nvarchar](100) NULL,
	[CreatedBy] [smallint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [smallint] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PaymentHistory]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaymentHistory](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FromUser] [varchar](20) NULL,
	[ToUser] [varchar](20) NULL,
	[FromUserType] [int] NULL,
	[ToUserType] [int] NULL,
	[AccountName] [varchar](100) NULL,
	[Address] [nvarchar](100) NULL,
	[Address1] [nvarchar](100) NULL,
	[City] [varchar](30) NULL,
	[State] [varchar](20) NULL,
	[Zip] [varchar](10) NULL,
	[CardNumber] [varchar](20) NULL,
	[CVS] [varchar](10) NULL,
	[Month] [varchar](20) NULL,
	[Year] [varchar](5) NULL,
	[LastFourDigitCard] [varchar](10) NULL,
	[IsCheckingAccount] [bit] NULL,
	[RoutingNo] [varchar](15) NULL,
	[AccountNo] [varchar](15) NULL,
	[CheckNo] [varchar](15) NULL,
	[AccountType] [varchar](15) NULL,
	[CreateDate] [datetime] NULL,
	[AuthorizationCode] [varchar](20) NULL,
	[TransactionCode] [varchar](200) NULL,
	[TransactionDescription] [varchar](100) NULL,
	[Getway] [varchar](50) NULL,
	[Status] [varchar](20) NULL,
	[Serial] [varchar](20) NULL,
	[TransactionType] [varchar](50) NULL,
	[LedgerCode] [varchar](20) NULL,
	[Remarks] [varchar](20) NULL,
	[SubscriptionType] [varchar](15) NULL,
	[IsStorageSubscription] [bit] NULL,
	[IsReceivedCommissions] [bit] NULL,
	[YTD_Commission] [varchar](20) NULL,
	[MTD_Commission] [varchar](20) NULL,
	[IsRecurring] [bit] NULL,
	[YTD_Contact_Export_Limit] [varchar](10) NULL,
	[MTD_Contact_Import_Limit] [varchar](10) NULL,
	[Contact_Storage_Limit] [varchar](10) NULL,
	[IsBillingCycleMonthly] [bit] NULL,
	[BasicAmount] [varchar](20) NULL,
	[StorageAmount] [varchar](20) NULL,
	[SubTotalCharge] [varchar](20) NULL,
	[Promocode] [varchar](100) NULL,
	[DiscountPercentage] [varchar](20) NULL,
	[Discount] [varchar](20) NULL,
	[CheckingAccountProcessingFee] [varchar](20) NULL,
	[GrossAmount] [varchar](20) NULL,
	[NetAmount] [varchar](20) NULL,
	[DebitAmount] [money] NULL,
	[CreditAmount] [money] NULL,
	[NoOfContact] [varchar](20) NULL,
	[ContactMultiplier] [varchar](20) NULL,
	[TotalContact] [varchar](20) NULL,
	[PerUnitCharge] [varchar](20) NULL,
	[MonthlyCharge] [varchar](20) NULL,
	[IsAgree] [bit] NULL,
 CONSTRAINT [PK_PaymentHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PaymentInformation]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentInformation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaymentInformation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](20) NULL,
	[AccountName] [varchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Address1] [nvarchar](100) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](20) NULL,
	[Zip] [varchar](10) NULL,
	[CardNumber] [varchar](25) NULL,
	[CVS] [varchar](5) NULL,
	[Month] [varchar](5) NULL,
	[Year] [varchar](5) NULL,
	[LastFourDigitCard] [varchar](5) NULL,
	[IsCheckingAccount] [bit] NULL,
	[RoutingNo] [varchar](25) NULL,
	[AccountNo] [varchar](25) NULL,
	[CheckNo] [varchar](25) NULL,
	[IsRecurring] [bit] NULL,
	[IsAgree] [bit] NULL,
 CONSTRAINT [PK_PaymentInformation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReferralAccount]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReferralAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReferralAccount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GiverPhone] [varchar](20) NULL,
	[GetterPhone] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[YTD_Commission] [varchar](20) NULL,
	[MTD_Commission] [varchar](20) NULL,
	[YTD_CommissionOwed] [varchar](20) NULL,
	[MTD_CommissionOwed] [varchar](20) NULL,
	[YTD_CommissionPaid] [varchar](20) NULL,
	[MTD_CommissionPaid] [varchar](20) NULL,
	[LastTransactionDate] [datetime] NULL,
 CONSTRAINT [PK_ReferralAccount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReferralTransaction]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReferralTransaction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReferralTransaction](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[GiverPhone] [varchar](20) NULL,
	[GetterPhone] [varchar](20) NULL,
	[TransactionDate] [datetime] NULL,
	[PayorAmount] [money] NULL,
	[Description] [varchar](200) NULL,
	[Month] [varchar](20) NULL,
	[Year] [varchar](5) NULL,
	[Remarks] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[CommissionMonthDate] [datetime] NULL,
	[IsPaid] [bit] NULL,
	[CommissionFor] [varchar](10) NULL,
	[ZipCode] [varchar](10) NULL,
 CONSTRAINT [PK_ReferralTransaction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[States]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[States]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[States](
	[STATE] [varchar](2) NOT NULL,
	[STATENAME] [varchar](50) NULL,
	[SalesTaxRate] [numeric](6, 3) NULL,
	[FreightTaxable] [char](1) NULL,
	[ShippingSurcharge] [numeric](6, 2) NULL,
 CONSTRAINT [PK_REFSTATES] PRIMARY KEY CLUSTERED 
(
	[STATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SystemInformation]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SystemInformation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SystemInformation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](20) NULL,
	[Website] [varchar](40) NULL,
	[EmailServer1] [varchar](40) NULL,
	[EmailUser1] [varchar](40) NULL,
	[EmailPassword1] [nvarchar](15) NULL,
	[EmailServer2] [varchar](40) NULL,
	[EmailUser2] [varchar](40) NULL,
	[EmailPassword2] [nvarchar](15) NULL,
	[EmailServer3] [varchar](40) NULL,
	[EmailUser3] [varchar](40) NULL,
	[EmailPassword3] [nvarchar](15) NULL,
	[EmailServer4] [varchar](40) NULL,
	[EmailUser4] [varchar](40) NULL,
	[EmailPassword4] [nvarchar](15) NULL,
	[SecurityLink] [varchar](40) NULL,
	[SecurityKey] [varchar](40) NULL,
	[SecurityUser] [varchar](40) NULL,
	[SecurityPassword] [nvarchar](15) NULL,
	[CreditCardLink] [varchar](40) NULL,
	[CreditCardKey] [varchar](40) NULL,
	[CreditCardUser] [varchar](40) NULL,
	[CreditCardPassword] [nvarchar](15) NULL,
	[DocumentLink] [varchar](40) NULL,
	[ApplicationFee] [decimal](18, 4) NULL,
	[FeeType] [smallint] NULL,
	[FeePercentage] [decimal](18, 4) NULL,
	[FeeFlatAmount] [decimal](18, 4) NULL,
	[IncludeProcessFees] [bit] NULL,
	[TanentPayFees] [bit] NULL,
	[CreditCardProcessFees] [decimal](18, 4) NULL,
	[OneTimePay] [bit] NULL,
	[RecurringPay] [bit] NULL,
	[IsGlobalSystem] [bit] NULL,
	[FeeTypeCheck] [smallint] NULL,
	[FeePercentageCheck] [decimal](18, 4) NULL,
	[FeeFlatAmountCheck] [decimal](18, 4) NULL,
 CONSTRAINT [PK_SystemInformation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserLog_Data]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserLog_Data]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserLog_Data](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[SessionId] [nvarchar](500) NULL,
	[UserId] [int] NULL,
	[LoginDate] [datetime] NULL,
	[Status] [bit] NULL,
	[LastUpdate] [datetime] NULL,
 CONSTRAINT [PK_UserLog_Data] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[UserPricing]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPricing]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserPricing](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserPlans] [varchar](20) NULL,
	[MonthlyCosts] [decimal](18, 2) NULL,
	[Billed] [varchar](20) NULL,
	[ContactsImportsMonthly] [varchar](10) NULL,
	[ContactExportsYearly] [varchar](10) NULL,
	[StoredContacts] [varchar](10) NULL,
	[Contacts_500] [varchar](10) NULL,
	[Contacts_10000] [varchar](10) NULL,
	[ReferralCommissions] [bit] NULL,
	[eTag365NFCChip] [bit] NULL,
 CONSTRAINT [PK_UserPricing] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserProfile]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserProfile]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserProfile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](30) NULL,
	[Serial] [varchar](20) NULL,
	[Password] [nvarchar](20) NULL,
	[Email] [varchar](50) NULL,
	[Phone] [varchar](30) NULL,
	[PhoneVerifyCode] [varchar](30) NULL,
	[FirstName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[ProfileLogo] [varchar](300) NULL,
	[CompanyName] [varchar](100) NULL,
	[CompanyLogo] [varchar](300) NULL,
	[WorkPhone] [varchar](30) NULL,
	[WorkPhoneExt] [varchar](30) NULL,
	[Fax] [varchar](30) NULL,
	[IsPhoneVerified] [bit] NULL,
	[IsNewUser] [bit] NULL,
	[IsAgree] [bit] NULL,
	[DoNotEmbedProfile] [bit] NULL,
	[DoNotEmbedCompany] [bit] NULL,
	[Address] [nvarchar](150) NULL,
	[Address1] [nvarchar](150) NULL,
	[Region] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[State] [varchar](20) NULL,
	[City] [varchar](30) NULL,
	[Zip] [varchar](10) NULL,
	[Other] [varchar](300) NULL,
	[DatabaseName] [varchar](50) NULL,
	[DatabaseLocation] [varchar](200) NULL,
	[UserTypeContact] [varchar](20) NULL,
	[IsAdmin] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsActive] [bit] NULL,
	[CanLogin] [bit] NULL,
	[IsUserProfileComplete] [bit] NULL,
	[IsBillingComplete] [bit] NULL,
	[IsOverwrite] [bit] NULL,
	[Website] [varchar](100) NULL,
	[Category] [varchar](30) NULL,
	[YTD_Contact_Export_Limit] [varchar](10) NULL,
	[YTD_Contact_Export] [varchar](10) NULL,
	[MTD_Contact_Import] [varchar](10) NULL,
	[MTD_Contact_Import_Limit] [varchar](10) NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](20) NULL,
	[UpdatedDate] [datetime] NULL,
	[RefPhone] [varchar](30) NULL,
	[Title] [varchar](100) NULL,
	[TypeOfContact] [varchar](30) NULL,
	[SubscriptionType] [varchar](20) NULL,
	[SubscriptionExpiredOn] [datetime] NULL,
	[StorageExpiredOn] [datetime] NULL,
	[IsStorageSubscription] [bit] NULL,
	[LastImportedDate] [datetime] NULL,
	[LastExportedDate] [datetime] NULL,
	[Contact_Storage_Limit] [varchar](10) NULL,
	[IsSentMail] [bit] NULL,
	[CountryCode] [varchar](5) NULL,
	[Longitude] [varchar](30) NULL,
	[Latitude] [varchar](30) NULL,
	[IsEmailFlow] [bit] NULL,
	[EmailFlowCreatedOn] [datetime] NULL,
 CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserType]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserType] [varchar](50) NULL,
	[UserDefineId] [int] NULL,
 CONSTRAINT [PK_UserType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Version]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Version]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Version](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[andVerCode] [varchar](20) NULL,
	[andVerLabel] [varchar](20) NULL,
	[andMustUpdate] [bit] NULL,
	[andVerNote] [varchar](max) NULL,
	[andLink] [varchar](255) NULL,
	[iOsVerCode] [varchar](20) NULL,
	[iOsVerLabel] [varchar](20) NULL,
	[iOsMustUpdate] [bit] NULL,
	[iOsLink] [varchar](255) NULL,
	[iOsVerNote] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Version] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[BillingPayment] ON 

GO
INSERT [dbo].[BillingPayment] ([Id], [UserId], [UserPhone], [SubscriptionType], [IsStorageSubscription], [IsReceivedCommissions], [SubscriptionExpiredOn], [StorageExpiredOn], [YTD_Contact_Export_Limit], [MTD_Contact_Import_Limit], [Contact_Storage_Limit], [IsBillingCycleMonthly], [IsBillingComplete], [ReferralStartDate], [ReferralEndDate], [IsCommissionMonthly], [YTD_Commission], [MTD_Commission], [CreateDate], [Status], [Remarks], [YTD_ReferralUser], [Total_ReferralUser], [ReferralRecycleDate], [LastReferralCalculatedDate], [IsRecurring], [BasicAmount], [StorageAmount], [SubTotalCharge], [Promocode], [DiscountPercentage], [Discount], [GrossAmount], [CheckingAccountProcessingFee], [NetAmount], [NoOfContact], [ContactMultiplier], [TotalContact], [PerUnitCharge], [MonthlyCharge], [IsAgree]) VALUES (1, N'1', N'8801817708660', N'Basic', 0, 1, CAST(0x0000AD24000C6BF5 AS DateTime), CAST(0x0000AD24000C6BF5 AS DateTime), N'250', N'10', N'500', 0, 1, CAST(0x0000AB8B000FA93B AS DateTime), CAST(0x0000AD24000C6C95 AS DateTime), 1, N'0.594', N'0.0495', CAST(0x0000AB8B000FA93B AS DateTime), N'complete', N'SubscriptionFee', N'1', N'1', CAST(0x0000AB8B000FA93B AS DateTime), NULL, 1, N'11.88', N'0', N'11.88', N'G0001', N'5', N'1', N'11.88', N'0', N'11.88', N'500', N'1', N'500', N'1', N'1', 1)
GO
INSERT [dbo].[BillingPayment] ([Id], [UserId], [UserPhone], [SubscriptionType], [IsStorageSubscription], [IsReceivedCommissions], [SubscriptionExpiredOn], [StorageExpiredOn], [YTD_Contact_Export_Limit], [MTD_Contact_Import_Limit], [Contact_Storage_Limit], [IsBillingCycleMonthly], [IsBillingComplete], [ReferralStartDate], [ReferralEndDate], [IsCommissionMonthly], [YTD_Commission], [MTD_Commission], [CreateDate], [Status], [Remarks], [YTD_ReferralUser], [Total_ReferralUser], [ReferralRecycleDate], [LastReferralCalculatedDate], [IsRecurring], [BasicAmount], [StorageAmount], [SubTotalCharge], [Promocode], [DiscountPercentage], [Discount], [GrossAmount], [CheckingAccountProcessingFee], [NetAmount], [NoOfContact], [ContactMultiplier], [TotalContact], [PerUnitCharge], [MonthlyCharge], [IsAgree]) VALUES (2, N'2', N'8801817708661', N'Gold', 0, 1, CAST(0x0000ACE700F0B00F AS DateTime), CAST(0x0000ACE700F0B00F AS DateTime), N'unlimited', N'unlimited', N'unlimited', 0, 1, CAST(0x0000AB7A00F0B00F AS DateTime), CAST(0x0000ACE700F0B00F AS DateTime), 1, N'0.594', N'0.0495', CAST(0x0000AB7A00F0B00F AS DateTime), N'complete', N'SubscriptionFee', N'0', N'0', CAST(0x0000AB7A00F0B00F AS DateTime), CAST(0x0000AB7A00F0B00F AS DateTime), 0, N'110.00', N'0.00', N'110.00', N'G0002', N'', N'110.00', N'11.88', N'0', N'0.00', N'', N'1', N'', N'0.00', N'0.00', 1)
GO
SET IDENTITY_INSERT [dbo].[BillingPayment] OFF
GO
SET IDENTITY_INSERT [dbo].[CalendarEntry] ON 

GO
INSERT [dbo].[CalendarEntry] ([Id], [UserName], [UserEmail], [UserId], [UserCode], [Timezone], [MeetingDate], [GMTTimeStart], [MeetingStartTime], [GMTTimeEnd], [MeetingEndTime], [Duration], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [TimeZoneDifference], [IsAvailable], [MeetingStartTimeShow]) VALUES (1, N'GEOFFREY TSUMA', N'aftab@2rsolution.com', N'1', N'U00000000001', N'Central', CAST(0x37450B00 AS Date), CAST(0x0000AFDC00735B40 AS DateTime), N'4/6/2023 1:00:00 AM', CAST(0x0000AFDC007B98A0 AS DateTime), N'4/6/2023 1:30:00 AM', 30, N'1', CAST(0x0000AE6E0000D81D AS DateTime), NULL, NULL, 6, 1, N'01:00 am')
GO
INSERT [dbo].[CalendarEntry] ([Id], [UserName], [UserEmail], [UserId], [UserCode], [Timezone], [MeetingDate], [GMTTimeStart], [MeetingStartTime], [GMTTimeEnd], [MeetingEndTime], [Duration], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [TimeZoneDifference], [IsAvailable], [MeetingStartTimeShow]) VALUES (2, N'GEOFFREY TSUMA', N'aftab@2rsolution.com', N'1', N'U00000000001', N'Central', CAST(0x37450B00 AS Date), CAST(0x0000AFDC014159A0 AS DateTime), N'4/6/2023 1:30:00 PM', CAST(0x0000AFDC01499700 AS DateTime), N'4/6/2023 2:00:00 PM', 30, N'1', CAST(0x0000AE6E0000D81D AS DateTime), NULL, NULL, 6, 1, N'01:30 pm')
GO
INSERT [dbo].[CalendarEntry] ([Id], [UserName], [UserEmail], [UserId], [UserCode], [Timezone], [MeetingDate], [GMTTimeStart], [MeetingStartTime], [GMTTimeEnd], [MeetingEndTime], [Duration], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [TimeZoneDifference], [IsAvailable], [MeetingStartTimeShow]) VALUES (3, N'GEOFFREY TSUMA', N'aftab@2rsolution.com', N'1', N'U00000000001', N'Central', CAST(0x37450B00 AS Date), CAST(0x0000AFDD00149970 AS DateTime), N'4/6/2023 7:15:00 PM', CAST(0x0000AFDD001CD6D0 AS DateTime), N'4/6/2023 7:45:00 PM', 30, N'1', CAST(0x0000AE6E0000D81D AS DateTime), NULL, NULL, 6, 1, N'07:15 pm')
GO
SET IDENTITY_INSERT [dbo].[CalendarEntry] OFF
GO
SET IDENTITY_INSERT [dbo].[CalendarSchedule] ON 

GO
INSERT [dbo].[CalendarSchedule] ([Id], [MeetingId], [UserName], [UserEmail], [UserId], [ToUserFirstName], [ToUserLastName], [ToUserEmail], [ToUserPhone], [ToUserCompany], [Notes], [Timezone], [TimeZoneDifference], [MeetingDate], [GMTTimeStart], [MeetingStartTime], [GMTTimeEnd], [MeetingEndTime], [Duration], [IsBooked], [IsSentEmail], [MeetingStartTimeShow]) VALUES (1, 1, N'GEOFFREY TSUMA', N'aftab@2rsolution.com', N'1', N'Mohammad', N'Aftabudduza', N'aftabudduza@gmail.com', N'01782394471', N'ADI', N'hello GEOFFREY TSUMA !!', N'Central', 6, CAST(0x37450B00 AS Date), CAST(0x0000AFDC00735B40 AS DateTime), N'4/6/2023 1:00:00 AM', CAST(0x0000AFDC007B98A0 AS DateTime), N'4/6/2023 1:30:00 AM', 30, 1, 1, N'01:00 am')
GO
INSERT [dbo].[CalendarSchedule] ([Id], [MeetingId], [UserName], [UserEmail], [UserId], [ToUserFirstName], [ToUserLastName], [ToUserEmail], [ToUserPhone], [ToUserCompany], [Notes], [Timezone], [TimeZoneDifference], [MeetingDate], [GMTTimeStart], [MeetingStartTime], [GMTTimeEnd], [MeetingEndTime], [Duration], [IsBooked], [IsSentEmail], [MeetingStartTimeShow]) VALUES (2, 3, N'GEOFFREY TSUMA', N'aftab@2rsolution.com', N'1', N'Mohammad', N'Aftabudduza', N'aftabudduza@gmail.com', N'01782394471', N'ADI', N'07:15 pm', N'Central', 6, CAST(0x37450B00 AS Date), CAST(0x0000AFDD00149970 AS DateTime), N'4/6/2023 7:15:00 PM', CAST(0x0000AFDD001CD6D0 AS DateTime), N'4/6/2023 7:45:00 PM', 30, 1, NULL, N'07:15 pm')
GO
INSERT [dbo].[CalendarSchedule] ([Id], [MeetingId], [UserName], [UserEmail], [UserId], [ToUserFirstName], [ToUserLastName], [ToUserEmail], [ToUserPhone], [ToUserCompany], [Notes], [Timezone], [TimeZoneDifference], [MeetingDate], [GMTTimeStart], [MeetingStartTime], [GMTTimeEnd], [MeetingEndTime], [Duration], [IsBooked], [IsSentEmail], [MeetingStartTimeShow]) VALUES (3, 2, N'GEOFFREY TSUMA', N'aftab@2rsolution.com', N'1', N'Mohammad', N'Aftabudduza', N'aftabudduza@gmail.com', N'01782394471', N'ADI', N'', N'Central', 6, CAST(0x37450B00 AS Date), CAST(0x0000AFDC014159A0 AS DateTime), N'4/6/2023 1:30:00 PM', CAST(0x0000AFDC01499700 AS DateTime), N'4/6/2023 2:00:00 PM', 30, 1, NULL, N'01:30 pm')
GO
SET IDENTITY_INSERT [dbo].[CalendarSchedule] OFF
GO
SET IDENTITY_INSERT [dbo].[Child] ON 

GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (1, 8, 8, N'Cash', N'Cash', NULL, 9, CAST(0x0000A8D90135E78D AS DateTime), NULL, NULL, N'')
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (2, 8, 8, N'Check', N'Check', NULL, 9, CAST(0x0000A8D901384B5B AS DateTime), NULL, NULL, N'')
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (9, 9, 9, N'Category1', N'Category1', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (10, 9, 9, N'Category2', N'Category2', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (12, 9, 9, N'Category3', N'Category 3', NULL, 2, CAST(0x0000AB8F0028FAE3 AS DateTime), NULL, NULL, N'2')
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (14, 9, 9, N'cat001', N'Personal', NULL, 1, CAST(0x0000AB99015E174C AS DateTime), NULL, NULL, N'1')
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (228, 4, 4, N'Abortion Policy', N'Abortion Policy', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (229, 4, 4, N'Accountants', N'Accountants', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (230, 4, 4, N'Advertising/Public Relations', N'Advertising/Public Relations', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (231, 4, 4, N'Aerospace, Defense Contractors', N'Aerospace, Defense Contractors', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (232, 4, 4, N'Agribusiness', N'Agribusiness', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (233, 4, 4, N'Agricultural Services & Products', N'Agricultural Services & Products', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (234, 4, 4, N'Agriculture', N'Agriculture', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (235, 4, 4, N'Air Transport', N'Air Transport', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (236, 4, 4, N'Air Transport Unions', N'Air Transport Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (237, 4, 4, N'Airlines', N'Airlines', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (238, 4, 4, N'Alcoholic Beverages', N'Alcoholic Beverages', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (239, 4, 4, N'Alternative Energy ', N'Alternative Energy ', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (240, 4, 4, N'Architectural Services', N'Architectural Services', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (241, 4, 4, N'Attorneys/Law Firms', N'Attorneys/Law Firms', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (242, 4, 4, N'Auto Dealers', N'Auto Dealers', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (243, 4, 4, N'Auto Dealers, Japanese', N'Auto Dealers, Japanese', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (244, 4, 4, N'Auto Manufacturers', N'Auto Manufacturers', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (245, 4, 4, N'Automotive', N'Automotive', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (246, 4, 4, N'Banking, Mortgage', N'Banking, Mortgage', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (247, 4, 4, N'Banks, Commercial', N'Banks, Commercial', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (248, 4, 4, N'Banks, Savings & Loans', N'Banks, Savings & Loans', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (249, 4, 4, N'Bars & Restaurants', N'Bars & Restaurants', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (250, 4, 4, N'Beer, Wine & Liquor', N'Beer, Wine & Liquor', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (251, 4, 4, N'Books, Magazines & Newspapers', N'Books, Magazines & Newspapers', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (252, 4, 4, N'Broadcasters, Radio/TV', N'Broadcasters, Radio/TV', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (253, 4, 4, N'Builders/General Contractors', N'Builders/General Contractors', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (254, 4, 4, N'Builders/Residential', N'Builders/Residential', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (255, 4, 4, N'Building Materials & Equipment', N'Building Materials & Equipment', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (256, 4, 4, N'Building Trade Unions', N'Building Trade Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (257, 4, 4, N'Business Associations', N'Business Associations', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (258, 4, 4, N'Business Services', N'Business Services', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (259, 4, 4, N'Cable & Satellite TV ', N'Cable & Satellite TV ', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (260, 4, 4, N'Car Dealers', N'Car Dealers', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (261, 4, 4, N'Car Dealers, Imports', N'Car Dealers, Imports', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (262, 4, 4, N'Car Manufacturers', N'Car Manufacturers', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (263, 4, 4, N'Carpet Cleaning', N'Carpet Cleaning', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (264, 4, 4, N'Casinos / Gambling', N'Casinos / Gambling', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (265, 4, 4, N'Cattle Ranchers/Livestock', N'Cattle Ranchers/Livestock', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (266, 4, 4, N'Chemical & Related Manufacturing', N'Chemical & Related Manufacturing', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (267, 4, 4, N'Chiropractors', N'Chiropractors', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (268, 4, 4, N'Civil Servants/Public Officials', N'Civil Servants/Public Officials', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (269, 4, 4, N'Clergy & Religious Organizations', N'Clergy & Religious Organizations', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (270, 4, 4, N'Clothing Manufacturing', N'Clothing Manufacturing', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (271, 4, 4, N'Coal Mining', N'Coal Mining', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (272, 4, 4, N'Colleges, Universities & Schools', N'Colleges, Universities & Schools', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (273, 4, 4, N'Commercial Banks', N'Commercial Banks', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (274, 4, 4, N'Commercial TV & Radio Stations', N'Commercial TV & Radio Stations', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (275, 4, 4, N'Communications/Electronics', N'Communications/Electronics', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (276, 4, 4, N'Computer Software', N'Computer Software', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (277, 4, 4, N'Conservative/Republican', N'Conservative/Republican', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (278, 4, 4, N'Construction', N'Construction', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (279, 4, 4, N'Construction Services', N'Construction Services', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (280, 4, 4, N'Construction Unions', N'Construction Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (281, 4, 4, N'Credit Unions', N'Credit Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (282, 4, 4, N'Crop Production & Basic Processing', N'Crop Production & Basic Processing', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (283, 4, 4, N'Cruise Lines', N'Cruise Lines', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (284, 4, 4, N'Cruise Ships & Lines', N'Cruise Ships & Lines', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (285, 4, 4, N'Dairy', N'Dairy', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (286, 4, 4, N'Defense', N'Defense', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (287, 4, 4, N'Defense Aerospace', N'Defense Aerospace', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (288, 4, 4, N'Defense Electronics', N'Defense Electronics', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (289, 4, 4, N'Defense/Foreign Policy Advocates', N'Defense/Foreign Policy Advocates', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (290, 4, 4, N'Democratic Candidate Committees', N'Democratic Candidate Committees', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (291, 4, 4, N'Democratic Leadership PACs', N'Democratic Leadership PACs', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (292, 4, 4, N'Democratic/Liberal', N'Democratic/Liberal', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (293, 4, 4, N'Dentists', N'Dentists', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (294, 4, 4, N'Doctors & Other Health Professionals', N'Doctors & Other Health Professionals', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (295, 4, 4, N'Drug Manufacturers', N'Drug Manufacturers', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (296, 4, 4, N'Education', N'Education', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (297, 4, 4, N'Electric Utilities', N'Electric Utilities', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (298, 4, 4, N'Electronics Manufacturing & Equipment', N'Electronics Manufacturing & Equipment', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (299, 4, 4, N'Electronics, Defense Contractors', N'Electronics, Defense Contractors', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (300, 4, 4, N'Energy & Natural Resources', N'Energy & Natural Resources', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (301, 4, 4, N'Entertainment Industry', N'Entertainment Industry', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (302, 4, 4, N'Environment', N'Environment', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (303, 4, 4, N'Farm Bureaus', N'Farm Bureaus', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (304, 4, 4, N'Farming', N'Farming', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (305, 4, 4, N'Finance / Credit Companies', N'Finance / Credit Companies', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (306, 4, 4, N'Finance, Insurance & Real Estate', N'Finance, Insurance & Real Estate', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (307, 4, 4, N'Food & Beverage', N'Food & Beverage', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (308, 4, 4, N'Food Processing & Sales', N'Food Processing & Sales', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (309, 4, 4, N'Food Products Manufacturing', N'Food Products Manufacturing', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (310, 4, 4, N'Food Stores', N'Food Stores', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (311, 4, 4, N'For-profit Education', N'For-profit Education', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (312, 4, 4, N'For-profit Prisons', N'For-profit Prisons', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (313, 4, 4, N'Foreign & Defense Policy', N'Foreign & Defense Policy', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (314, 4, 4, N'Forestry & Forest Products', N'Forestry & Forest Products', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (315, 4, 4, N'Foundations, Philanthropists ', N'Foundations, Philanthropists ', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (316, 4, 4, N'Funeral Services', N'Funeral Services', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (317, 4, 4, N'Gambling & Casinos', N'Gambling & Casinos', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (318, 4, 4, N'Gambling, Indian Casinos', N'Gambling, Indian Casinos', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (319, 4, 4, N'Garbage Collection/Waste', N'Garbage Collection/Waste', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (320, 4, 4, N'Gas & Oil', N'Gas & Oil', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (321, 4, 4, N'Gay & Lesbian Rights & Issues', N'Gay & Lesbian Rights & Issues', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (322, 4, 4, N'General Contractors', N'General Contractors', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (323, 4, 4, N'Government Employee Unions', N'Government Employee Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (324, 4, 4, N'Government Employees', N'Government Employees', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (325, 4, 4, N'Gun Control', N'Gun Control', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (326, 4, 4, N'Gun Rights', N'Gun Rights', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (327, 4, 4, N'Health', N'Health', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (328, 4, 4, N'Health Professionals', N'Health Professionals', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (329, 4, 4, N'Health Services/HMOs', N'Health Services/HMOs', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (330, 4, 4, N'Hedge Funds', N'Hedge Funds', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (331, 4, 4, N'HMOs & Health Care Services', N'HMOs & Health Care Services', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (332, 4, 4, N'Home Builders', N'Home Builders', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (333, 4, 4, N'Hospitals & Nursing Homes', N'Hospitals & Nursing Homes', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (334, 4, 4, N'Hotels, Motels & Tourism', N'Hotels, Motels & Tourism', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (335, 4, 4, N'Human Rights', N'Human Rights', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (336, 4, 4, N'Ideological/Single-Issue', N'Ideological/Single-Issue', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (337, 4, 4, N'Indian Gaming', N'Indian Gaming', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (338, 4, 4, N'Industrial Unions', N'Industrial Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (339, 4, 4, N'Insurance', N'Insurance', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (340, 4, 4, N'Internet', N'Internet', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (341, 4, 4, N'Labor', N'Labor', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (342, 4, 4, N'Lawyers & Lobbyists', N'Lawyers & Lobbyists', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (343, 4, 4, N'Lawyers / Law Firms', N'Lawyers / Law Firms', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (344, 4, 4, N'Leadership PACs', N'Leadership PACs', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (345, 4, 4, N'Liberal/Democratic', N'Liberal/Democratic', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (346, 4, 4, N'Liquor, Wine & Beer', N'Liquor, Wine & Beer', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (347, 4, 4, N'Livestock', N'Livestock', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (348, 4, 4, N'Lobbyists', N'Lobbyists', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (349, 4, 4, N'Lodging / Tourism', N'Lodging / Tourism', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (350, 4, 4, N'Logging, Timber & Paper Mills', N'Logging, Timber & Paper Mills', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (351, 4, 4, N'Manufacturing, Misc', N'Manufacturing, Misc', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (352, 4, 4, N'Marijuana', N'Marijuana', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (353, 4, 4, N'Marine Transport', N'Marine Transport', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (354, 4, 4, N'Meat processing & products', N'Meat processing & products', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (355, 4, 4, N'Medical Supplies', N'Medical Supplies', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (356, 4, 4, N'Mining', N'Mining', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (357, 4, 4, N'Misc Business', N'Misc Business', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (358, 4, 4, N'Misc Finance', N'Misc Finance', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (359, 4, 4, N'Misc Manufacturing & Distributing', N'Misc Manufacturing & Distributing', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (360, 4, 4, N'Misc Unions', N'Misc Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (361, 4, 4, N'Miscellaneous Defense', N'Miscellaneous Defense', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (362, 4, 4, N'Miscellaneous Services', N'Miscellaneous Services', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (363, 4, 4, N'Mortgage Bankers & Brokers', N'Mortgage Bankers & Brokers', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (364, 4, 4, N'Motion Picture Production & Distribution', N'Motion Picture Production & Distribution', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (365, 4, 4, N'Music Production', N'Music Production', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (366, 4, 4, N'Natural Gas Pipelines', N'Natural Gas Pipelines', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (367, 4, 4, N'Newspaper, Magazine & Book Publishing', N'Newspaper, Magazine & Book Publishing', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (368, 4, 4, N'Non-profits, Foundations & Philanthropists', N'Non-profits, Foundations & Philanthropists', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (369, 4, 4, N'Nurses', N'Nurses', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (370, 4, 4, N'Nursing Homes/Hospitals', N'Nursing Homes/Hospitals', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (371, 4, 4, N'Nutritional & Dietary Supplements', N'Nutritional & Dietary Supplements', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (372, 4, 4, N'Oil & Gas', N'Oil & Gas', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (373, 4, 4, N'Other', N'Other', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (374, 4, 4, N'Payday Lenders', N'Payday Lenders', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (375, 4, 4, N'Pharmaceutical Manufacturing', N'Pharmaceutical Manufacturing', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (376, 4, 4, N'Pharmaceuticals / Health Products', N'Pharmaceuticals / Health Products', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (377, 4, 4, N'Phone Companies', N'Phone Companies', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (378, 4, 4, N'Physicians & Other Health Professionals', N'Physicians & Other Health Professionals', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (379, 4, 4, N'Postal Unions', N'Postal Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (380, 4, 4, N'Poultry & Eggs', N'Poultry & Eggs', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (381, 4, 4, N'Power Utilities', N'Power Utilities', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (382, 4, 4, N'Printing & Publishing', N'Printing & Publishing', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (383, 4, 4, N'Private Equity & Investment Firms', N'Private Equity & Investment Firms', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (384, 4, 4, N'Pro-Israel', N'Pro-Israel', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (385, 4, 4, N'Professional Sports, Sports Arenas & Related Equipment & Services', N'Professional Sports, Sports Arenas & Related Equipment & Services', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (386, 4, 4, N'Progressive/Democratic', N'Progressive/Democratic', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (387, 4, 4, N'Public Employees', N'Public Employees', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (388, 4, 4, N'Public Sector Unions', N'Public Sector Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (389, 4, 4, N'Publishing & Printing', N'Publishing & Printing', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (390, 4, 4, N'Radio/TV Stations', N'Radio/TV Stations', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (391, 4, 4, N'Railroads', N'Railroads', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (392, 4, 4, N'Real Estate', N'Real Estate', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (393, 4, 4, N'Record Companies/Singers', N'Record Companies/Singers', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (394, 4, 4, N'Recorded Music & Music Production', N'Recorded Music & Music Production', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (395, 4, 4, N'Recreation / Live Entertainment', N'Recreation / Live Entertainment', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (396, 4, 4, N'Religious Organizations/Clergy', N'Religious Organizations/Clergy', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (397, 4, 4, N'Republican Candidate Committees', N'Republican Candidate Committees', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (398, 4, 4, N'Republican Leadership PACs', N'Republican Leadership PACs', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (399, 4, 4, N'Republican/Conservative', N'Republican/Conservative', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (400, 4, 4, N'Residential Construction', N'Residential Construction', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (401, 4, 4, N'Restaurants & Drinking Establishments', N'Restaurants & Drinking Establishments', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (402, 4, 4, N'Retail Sales', N'Retail Sales', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (403, 4, 4, N'Retired', N'Retired', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (404, 4, 4, N'Savings & Loans', N'Savings & Loans', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (405, 4, 4, N'Schools/Education', N'Schools/Education', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (406, 4, 4, N'Sea Transport', N'Sea Transport', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (407, 4, 4, N'Securities & Investment', N'Securities & Investment', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (408, 4, 4, N'Special Trade Contractors', N'Special Trade Contractors', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (409, 4, 4, N'Sports, Professional', N'Sports, Professional', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (410, 4, 4, N'Steel Production', N'Steel Production', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (411, 4, 4, N'Stock Brokers/Investment Industry', N'Stock Brokers/Investment Industry', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (412, 4, 4, N'Student Loan Companies', N'Student Loan Companies', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (413, 4, 4, N'Sugar Cane & Sugar Beets', N'Sugar Cane & Sugar Beets', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (414, 4, 4, N'Teachers Unions', N'Teachers Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (415, 4, 4, N'Teachers/Education', N'Teachers/Education', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (416, 4, 4, N'Telecom Services & Equipment', N'Telecom Services & Equipment', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (417, 4, 4, N'Telephone Utilities', N'Telephone Utilities', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (418, 4, 4, N'Textiles', N'Textiles', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (419, 4, 4, N'Timber, Logging & Paper Mills', N'Timber, Logging & Paper Mills', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (420, 4, 4, N'Tobacco', N'Tobacco', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (421, 4, 4, N'Transportation', N'Transportation', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (422, 4, 4, N'Transportation Unions', N'Transportation Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (423, 4, 4, N'Trash Collection/Waste Management', N'Trash Collection/Waste Management', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (424, 4, 4, N'Trucking', N'Trucking', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (425, 4, 4, N'TV / Movies / Music', N'TV / Movies / Music', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (426, 4, 4, N'TV Production', N'TV Production', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (427, 4, 4, N'Unions', N'Unions', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (428, 4, 4, N'Unions, Airline', N'Unions, Airline', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (429, 4, 4, N'Unions, Building Trades', N'Unions, Building Trades', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (430, 4, 4, N'Unions, Industrial', N'Unions, Industrial', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (431, 4, 4, N'Unions, Misc', N'Unions, Misc', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (432, 4, 4, N'Unions, Public Sector', N'Unions, Public Sector', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (433, 4, 4, N'Unions, Teacher', N'Unions, Teacher', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (434, 4, 4, N'Unions, Transportation', N'Unions, Transportation', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (435, 4, 4, N'Universities, Colleges & Schools', N'Universities, Colleges & Schools', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (436, 4, 4, N'Vegetables & Fruits', N'Vegetables & Fruits', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (437, 4, 4, N'Venture Capital', N'Venture Capital', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (438, 4, 4, N'Waste Management', N'Waste Management', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (439, 4, 4, N'Wine, Beer & Liquor', N'Wine, Beer & Liquor', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Child] ([Id], [ParentId], [UserDefinedId], [Code], [Description], [CompanyId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [OwnerId]) VALUES (440, 4, 4, N'Women''s Issues', N'Women''s Issues', NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Child] OFF
GO
SET IDENTITY_INSERT [dbo].[ContactInformation] ON 

GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1, N'2', N'Aftab', NULL, N'Udduza', N'aftabudduza@gmail.com', NULL, NULL, NULL, NULL, N'ny', N'new york', NULL, N'8801817708660', NULL, NULL, NULL, NULL, NULL, NULL, N'2RSolution Ltd', NULL, 0, 1, NULL, NULL, N'2', CAST(0x0000AB5F0104EBFA AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'880', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (2, N'1', N'John', NULL, N'Doe', N'aftab@gmail.com', N'100 North Street', N'100 North Street', N'NY', N'BD', N'NY', N'New York', N'19034', N'8801817708661', N'', N'', N'', N'', N'Personal', NULL, N'', NULL, NULL, NULL, NULL, N'', NULL, NULL, N'1', CAST(0x0000AC30000D09A1 AS DateTime), N'', N'John Doe', N'', N'', N'880', N'', N'', 0)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (20, N'11', N'Shakil', NULL, N'Azad', N'befresh@gmail.com', NULL, N'GEC', NULL, N'US', N'AL', N'CTG', NULL, N'8801817708660', N'8801819123123', N'123', N'12345678109', N'test.com', N'Category1', NULL, N'US', NULL, 0, 1, NULL, N'test', N'11', CAST(0x0000ABD5015A66AF AS DateTime), NULL, NULL, N'8801816321654', NULL, N'Phone', NULL, N'880', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (21, N'1', N'Shakil', NULL, NULL, NULL, NULL, NULL, NULL, N'US', NULL, NULL, NULL, N'8801817708662', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, N'1', CAST(0x0000ABD5015A66CA AS DateTime), NULL, NULL, NULL, NULL, N'Phone', NULL, N'880', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (22, N'1', N'Joe', NULL, N'Clean', N'abc@etag.com', NULL, NULL, NULL, N'US', N'PA', NULL, NULL, N'8801817708663', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, N'1', CAST(0x0000ABF700134184 AS DateTime), NULL, NULL, NULL, N'Lead Engineer', NULL, NULL, N'880', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (23, N'1', N'John', N'', N'Clean', N'abc@a.com', NULL, NULL, NULL, N'US', NULL, NULL, NULL, N'8801817708665', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, N'1', CAST(0x0000ABF7001FFF6D AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'880', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (24, N'1', N'Joe', NULL, N'Clean', N'clean@etag.com', NULL, NULL, NULL, N'US', NULL, NULL, NULL, N'8801817708667', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, N'8801817708660', CAST(0x0000ABF700217548 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'880', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (25, N'1', N'Jamal', NULL, N'Heacock', N'a@a.com', N'100 North Street.', NULL, NULL, N'US', N'PA', N'New York City', N'19134', N'12676201170', N'267-620-1171', N'1207', N'267-620-1175', N'www.gastropa.com', NULL, NULL, N'Aeroflot Airlines, a.s', NULL, 0, 1, NULL, NULL, N'8801817708660', CAST(0x0000ABFE000D1289 AS DateTime), NULL, NULL, N'8801817708660', N'IT Manager', NULL, NULL, N'1', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (26, N'1', N'Shenzhen Xinyetong Technology', NULL, NULL, NULL, N'16th Floor, Jingyuan Masion', NULL, NULL, N'US', N'Shenzhen', N'Longgang District', N'518112', N'18682346130', N'755-26979016', NULL, N'755-86593863', NULL, NULL, NULL, N'Shenzhen Xinyetong Technology Co.,Ltd.', NULL, 0, 1, N'2', NULL, N'8801817708660', CAST(0x0000AC03002A2D75 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'1', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (27, N'1', N'Jamal', N'', N'Heacock', N'jamal@gastropa.com', N'2000 AVENUE OF THE STARS, LOS ANGELES', NULL, NULL, N'US', N'CA', N'LOS ANGELES', N'90067', N'12676201171', N'267-620-1171', NULL, N'267-620-1175', N'www.etag365.com', NULL, NULL, N'Shenzhen Xinyetong Technology Co.,Ltd', NULL, 0, 1, N'2', NULL, N'8801817708660', CAST(0x0000AC04015F6865 AS DateTime), NULL, NULL, N'267-620-1176', N'IT Manager', NULL, NULL, N'1', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (30, N'1', N'Jamal', N'', N'Heacock', N'jamal@gastropa.com', N'2000 AVENUE OF THE STARS, LOS ANGELES', NULL, NULL, N'US', N'CA', N'LOS ANGELES', N'90067', N'12676201177', N'267-620-1171', N'1207', N'267-620-1175', N'www.etag365.com', NULL, NULL, N'Shenzhen Xinyetong Technology Co.,Ltd', NULL, 0, 1, N'2', NULL, N'8801817708660', CAST(0x0000AC040160A45F AS DateTime), NULL, NULL, N'267-620-1176', N'IT Manager', NULL, NULL, N'1', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (31, N'1', N'Jamal', N'', N'Heacock', N'jamal@gastropa.com', N'2000 AVENUE OF THE STARS, LOS ANGELES', NULL, NULL, N'US', N'CA', N'LOS ANGELES', N'90067', N'12676201173', N'267-620-1171', N'0', N'267-620-1175', N'www.etag365.com', N'3', NULL, N'Shenzhen Xinyetong Technology Co.,Ltd', NULL, 0, 1, N'2', NULL, N'8801817708660', CAST(0x0000AC05015F3509 AS DateTime), NULL, NULL, N'267-620-1176', N'IT Manager', NULL, NULL, N'1', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (32, N'2', N'John', N'', N'Doe', N'aftab@2rsolution.com', N'1222', N'', N'INDIANA', N'US', N'IN', N'test', N'15000', N'12016351269', N'201-481-5542', N'232', N'201-531-2269', N'', N'Category1', NULL, N'ADI', NULL, 0, 1, N'2', N'', N'8801817708660', CAST(0x0000AC08001B669D AS DateTime), N'2', CAST(0x0000AC28010FB7D5 AS DateTime), N'', N'', N'Other', N'', N'1', N'', N'', 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1026, N'1', N'Somers (Sandy)', NULL, N'Butcher', N'skbutcher@myfileit.com', N'809 N Bethlehem Pike', N'Spring House Square Bldg. B Rear', N'', N'US', N'PA', N'Lower Gwynedd', N'19002', N'12156691499', N'2152335300', N'1207', N'2152331825', N'www.myfileit.com', N'Category1', NULL, N'Myfileit Inc', NULL, 0, 1, NULL, N'', N'1', CAST(0x0000AC15011D9939 AS DateTime), N'1', CAST(0x0000ACFE00EB5AFF AS DateTime), N'2156691499', N'President', N'', N'', N'1', N'', N'', 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1027, N'1', N'Donna', N'', N'Bell', N'aftab@2rsolution.com', N'100 Main street', N'', N'INDIANA', N'US', N'IN', N'test', N'15000', N'12153335656', N'', N'', N'', N'www.serverpro.com', N'Category1', NULL, N'', NULL, 0, 1, N'2', N'', N'8801817708660', CAST(0x0000AC26010478B2 AS DateTime), N'1', CAST(0x0000AC300002B15F AS DateTime), N'', N'Serpro', N'Main', N'', N'1', N'', N'', 0)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1028, N'25', N'Sandy', NULL, N'Butcher', N' aftab@2rsolution.com ', N'809 N Bethlehem Pike ', N' Spring House Square Bldg B Suite BR ', NULL, N'US', N'PA', N'Ambler ', N'19002', N'12156691499', N'2156691499', N'1207', N'2152331825', N'test.com', N'ADI', NULL, N' eTag365', NULL, 0, 1, NULL, N' No Typing Information - Right Every Time -Saves hundreds hours of input per year. Reduce Your Printing Cost. Cancel anytime. First 30 days money back.Easy export to favor CRM ', N'25', CAST(0x0000AC280115DCD0 AS DateTime), NULL, NULL, N'2156691499', N'President ', N'Work', NULL, N'1', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1029, N'24', N'Shakil', NULL, NULL, NULL, NULL, NULL, NULL, N'US', NULL, NULL, NULL, N'8801819330330', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, N'24', CAST(0x0000AC280115DD0D AS DateTime), NULL, NULL, NULL, NULL, N'Phone', NULL, N'880', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1030, N'25', N'Sandy', NULL, N'Butcher', N' a@etag365.com ', N'809 N Bethlehem Pike ', N' Spring House Square Bldg B Suite BR ', NULL, N'US', N'PA', N'Ambler ', N'19002', N'12156691498', N'2156691499', N'1207', N'2152331825', N'test.com', N'ADI', NULL, N' eTag365', NULL, 0, 1, NULL, N' No Typing Information - Right Every Time -Saves hundreds hours of input per year. Reduce Your Printing Cost. Cancel anytime. First 30 days money back.Easy export to favor CRM ', N'25', CAST(0x0000AC28011A70A3 AS DateTime), NULL, NULL, N'2156691499', N'President ', N'Work', NULL, N'1', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1031, N'26', N'Shakil', NULL, NULL, NULL, NULL, NULL, NULL, N'US', NULL, NULL, NULL, N'8801819330330', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, N'26', CAST(0x0000AC28011A70B3 AS DateTime), NULL, NULL, NULL, NULL, N'Phone', NULL, N'880', NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1032, N'1', N'John', N'', N'Doe', N'aftab@2rsolution.com', N'100 North Street', N'', N'NY', N'US', N'NY', N'New York', N'19034', N'12123335678', N'NULL', N'NULL', N'NULL', N'NA', N'Category1', NULL, NULL, NULL, NULL, 1, N'2', NULL, N'1', CAST(0x0000ACD100135A9A AS DateTime), NULL, NULL, N'NULL', N'John Doe', N'Phone', NULL, NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1033, N'1', N'Donna', N'', N'Bell', N'sbutcher@myfileit.com', N'100 Main street', NULL, NULL, N'US', N'PA', N'Norristown', N'19045', N'12152335300', N'215-333-5656', N'1207', N'215-333-5656', N'www.serverpro.com', N'Category1', NULL, N'Serpro', NULL, 0, 1, N'2', NULL, N'8801817708660', CAST(0x0000ACDE015785B0 AS DateTime), NULL, NULL, N'215-333-5656', NULL, N'Main', NULL, NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1034, N'1', N'John', N'', N'Doe', N'abc@a.com', N'100 North Street', N'', N'NY', N'US', N'NY', N'New York', N'19034', N'12123335679', N'NULL', N'NULL', N'NULL', NULL, N'Category1', NULL, NULL, NULL, NULL, 1, N'2', NULL, N'1', CAST(0x0000ACFB01180111 AS DateTime), NULL, NULL, N'NULL', N'John Doe', N'Phone', NULL, NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1036, N'1', N'GEOFFREY', NULL, N'TSUMA', N'abc@adi.com', NULL, NULL, NULL, N'US', NULL, NULL, NULL, N'14046451335', NULL, NULL, NULL, NULL, NULL, NULL, N'ABC', NULL, 0, 1, NULL, NULL, N'1', CAST(0x0000AD2000CC5055 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'1', NULL, NULL, 0)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1037, N'1027', N'Aftab', NULL, NULL, NULL, NULL, NULL, NULL, N'US', NULL, NULL, NULL, N'8801817708660', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, N'1027', CAST(0x0000AD2000CC5AD6 AS DateTime), NULL, NULL, NULL, NULL, N'Phone', NULL, N'880', NULL, NULL, 0)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1040, N'1', N'John', N'', N'Doe', N'a@a.com', N'100 North Street', N'', N'NY', N'US', N'NY', N'New York', N'19034', N'12123335670', N'NULL', N'NULL', N'NULL', N'abc.com', N'Category1', NULL, N'ABC', NULL, NULL, 1, N'2', NULL, N'8801817708660', CAST(0x0000AD230111BD0E AS DateTime), NULL, NULL, N'NULL', N'John Doe', N'Phone', NULL, NULL, NULL, NULL, 1)
GO
INSERT [dbo].[ContactInformation] ([Id], [UserId], [FirstName], [MiddleName], [LastName], [Email], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Phone], [WorkPhone], [WorkPhoneExt], [Fax], [Website], [Category], [ProfileLogo], [CompanyName], [IsOverwrite], [IsDeleted], [IsActive], [UserTypeContact], [Other], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [Memo], [CountryCode], [Longitude], [Latitude], [IsEmailFlow]) VALUES (1041, N'1', N'John', N'', N'Doe', N'a@a.com', N'100 North Street', N'', N'NY', N'US', N'NY', N'New York', N'19034', N'12021121234', N'NULL', N'NULL', N'NULL', N'abc.com', N'Category1', NULL, N'ABC', NULL, NULL, 1, N'2', NULL, N'8801817708660', CAST(0x0000AE1B001BA263 AS DateTime), NULL, NULL, N'NULL', N'John Doe', N'Phone', NULL, NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[ContactInformation] OFF
GO
SET IDENTITY_INSERT [dbo].[Country] ON 

GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (1, N'AF', N'AFGHANISTAN', N'Afghanistan', N'AFG', 4, 93)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (2, N'AL', N'ALBANIA', N'Albania', N'ALB', 8, 355)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (3, N'DZ', N'ALGERIA', N'Algeria', N'DZA', 12, 213)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (4, N'AS', N'AMERICAN SAMOA', N'American Samoa', N'ASM', 16, 1684)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (5, N'AD', N'ANDORRA', N'Andorra', N'AND', 20, 376)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (6, N'AO', N'ANGOLA', N'Angola', N'AGO', 24, 244)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (7, N'AI', N'ANGUILLA', N'Anguilla', N'AIA', 660, 1264)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (8, N'AQ', N'ANTARCTICA', N'Antarctica', NULL, NULL, 0)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (9, N'AG', N'ANTIGUA AND BARBUDA', N'Antigua and Barbuda', N'ATG', 28, 1268)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (10, N'AR', N'ARGENTINA', N'Argentina', N'ARG', 32, 54)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (11, N'AM', N'ARMENIA', N'Armenia', N'ARM', 51, 374)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (12, N'AW', N'ARUBA', N'Aruba', N'ABW', 533, 297)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (13, N'AU', N'AUSTRALIA', N'Australia', N'AUS', 36, 61)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (14, N'AT', N'AUSTRIA', N'Austria', N'AUT', 40, 43)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (15, N'AZ', N'AZERBAIJAN', N'Azerbaijan', N'AZE', 31, 994)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (16, N'BS', N'BAHAMAS', N'Bahamas', N'BHS', 44, 1242)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (17, N'BH', N'BAHRAIN', N'Bahrain', N'BHR', 48, 973)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (18, N'BD', N'BANGLADESH', N'Bangladesh', N'BGD', 50, 880)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (19, N'BB', N'BARBADOS', N'Barbados', N'BRB', 52, 1246)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (20, N'BY', N'BELARUS', N'Belarus', N'BLR', 112, 375)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (21, N'BE', N'BELGIUM', N'Belgium', N'BEL', 56, 32)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (22, N'BZ', N'BELIZE', N'Belize', N'BLZ', 84, 501)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (23, N'BJ', N'BENIN', N'Benin', N'BEN', 204, 229)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (24, N'BM', N'BERMUDA', N'Bermuda', N'BMU', 60, 1441)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (25, N'BT', N'BHUTAN', N'Bhutan', N'BTN', 64, 975)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (26, N'BO', N'BOLIVIA', N'Bolivia', N'BOL', 68, 591)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (27, N'BA', N'BOSNIA AND HERZEGOVINA', N'Bosnia and Herzegovina', N'BIH', 70, 387)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (28, N'BW', N'BOTSWANA', N'Botswana', N'BWA', 72, 267)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (29, N'BV', N'BOUVET ISLAND', N'Bouvet Island', NULL, NULL, 0)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (30, N'BR', N'BRAZIL', N'Brazil', N'BRA', 76, 55)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (31, N'IO', N'BRITISH INDIAN OCEAN TERRITORY', N'British Indian Ocean Territory', NULL, NULL, 246)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (32, N'BN', N'BRUNEI DARUSSALAM', N'Brunei Darussalam', N'BRN', 96, 673)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (33, N'BG', N'BULGARIA', N'Bulgaria', N'BGR', 100, 359)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (34, N'BF', N'BURKINA FASO', N'Burkina Faso', N'BFA', 854, 226)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (35, N'BI', N'BURUNDI', N'Burundi', N'BDI', 108, 257)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (36, N'KH', N'CAMBODIA', N'Cambodia', N'KHM', 116, 855)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (37, N'CM', N'CAMEROON', N'Cameroon', N'CMR', 120, 237)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (38, N'CA', N'CANADA', N'Canada', N'CAN', 124, 1)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (39, N'CV', N'CAPE VERDE', N'Cape Verde', N'CPV', 132, 238)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (40, N'KY', N'CAYMAN ISLANDS', N'Cayman Islands', N'CYM', 136, 1345)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (41, N'CF', N'CENTRAL AFRICAN REPUBLIC', N'Central African Republic', N'CAF', 140, 236)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (42, N'TD', N'CHAD', N'Chad', N'TCD', 148, 235)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (43, N'CL', N'CHILE', N'Chile', N'CHL', 152, 56)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (44, N'CN', N'CHINA', N'China', N'CHN', 156, 86)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (45, N'CX', N'CHRISTMAS ISLAND', N'Christmas Island', NULL, NULL, 61)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (46, N'CC', N'COCOS (KEELING) ISLANDS', N'Cocos (Keeling) Islands', NULL, NULL, 672)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (47, N'CO', N'COLOMBIA', N'Colombia', N'COL', 170, 57)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (48, N'KM', N'COMOROS', N'Comoros', N'COM', 174, 269)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (49, N'CG', N'CONGO', N'Congo', N'COG', 178, 242)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (50, N'CD', N'CONGO, THE DEMOCRATIC REPUBLIC OF THE', N'Congo, the Democratic Republic of the', N'COD', 180, 242)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (51, N'CK', N'COOK ISLANDS', N'Cook Islands', N'COK', 184, 682)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (52, N'CR', N'COSTA RICA', N'Costa Rica', N'CRI', 188, 506)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (53, N'CI', N'COTE D''IVOIRE', N'Cote D''Ivoire', N'CIV', 384, 225)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (54, N'HR', N'CROATIA', N'Croatia', N'HRV', 191, 385)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (55, N'CU', N'CUBA', N'Cuba', N'CUB', 192, 53)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (56, N'CY', N'CYPRUS', N'Cyprus', N'CYP', 196, 357)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (57, N'CZ', N'CZECH REPUBLIC', N'Czech Republic', N'CZE', 203, 420)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (58, N'DK', N'DENMARK', N'Denmark', N'DNK', 208, 45)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (59, N'DJ', N'DJIBOUTI', N'Djibouti', N'DJI', 262, 253)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (60, N'DM', N'DOMINICA', N'Dominica', N'DMA', 212, 1767)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (61, N'DO', N'DOMINICAN REPUBLIC', N'Dominican Republic', N'DOM', 214, 1809)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (62, N'EC', N'ECUADOR', N'Ecuador', N'ECU', 218, 593)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (63, N'EG', N'EGYPT', N'Egypt', N'EGY', 818, 20)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (64, N'SV', N'EL SALVADOR', N'El Salvador', N'SLV', 222, 503)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (65, N'GQ', N'EQUATORIAL GUINEA', N'Equatorial Guinea', N'GNQ', 226, 240)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (66, N'ER', N'ERITREA', N'Eritrea', N'ERI', 232, 291)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (67, N'EE', N'ESTONIA', N'Estonia', N'EST', 233, 372)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (68, N'ET', N'ETHIOPIA', N'Ethiopia', N'ETH', 231, 251)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (69, N'FK', N'FALKLAND ISLANDS (MALVINAS)', N'Falkland Islands (Malvinas)', N'FLK', 238, 500)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (70, N'FO', N'FAROE ISLANDS', N'Faroe Islands', N'FRO', 234, 298)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (71, N'FJ', N'FIJI', N'Fiji', N'FJI', 242, 679)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (72, N'FI', N'FINLAND', N'Finland', N'FIN', 246, 358)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (73, N'FR', N'FRANCE', N'France', N'FRA', 250, 33)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (74, N'GF', N'FRENCH GUIANA', N'French Guiana', N'GUF', 254, 594)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (75, N'PF', N'FRENCH POLYNESIA', N'French Polynesia', N'PYF', 258, 689)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (76, N'TF', N'FRENCH SOUTHERN TERRITORIES', N'French Southern Territories', NULL, NULL, 0)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (77, N'GA', N'GABON', N'Gabon', N'GAB', 266, 241)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (78, N'GM', N'GAMBIA', N'Gambia', N'GMB', 270, 220)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (79, N'GE', N'GEORGIA', N'Georgia', N'GEO', 268, 995)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (80, N'DE', N'GERMANY', N'Germany', N'DEU', 276, 49)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (81, N'GH', N'GHANA', N'Ghana', N'GHA', 288, 233)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (82, N'GI', N'GIBRALTAR', N'Gibraltar', N'GIB', 292, 350)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (83, N'GR', N'GREECE', N'Greece', N'GRC', 300, 30)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (84, N'GL', N'GREENLAND', N'Greenland', N'GRL', 304, 299)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (85, N'GD', N'GRENADA', N'Grenada', N'GRD', 308, 1473)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (86, N'GP', N'GUADELOUPE', N'Guadeloupe', N'GLP', 312, 590)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (87, N'GU', N'GUAM', N'Guam', N'GUM', 316, 1671)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (88, N'GT', N'GUATEMALA', N'Guatemala', N'GTM', 320, 502)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (89, N'GN', N'GUINEA', N'Guinea', N'GIN', 324, 224)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (90, N'GW', N'GUINEA-BISSAU', N'Guinea-Bissau', N'GNB', 624, 245)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (91, N'GY', N'GUYANA', N'Guyana', N'GUY', 328, 592)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (92, N'HT', N'HAITI', N'Haiti', N'HTI', 332, 509)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (93, N'HM', N'HEARD ISLAND AND MCDONALD ISLANDS', N'Heard Island and Mcdonald Islands', NULL, NULL, 0)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (94, N'VA', N'HOLY SEE (VATICAN CITY STATE)', N'Holy See (Vatican City State)', N'VAT', 336, 39)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (95, N'HN', N'HONDURAS', N'Honduras', N'HND', 340, 504)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (96, N'HK', N'HONG KONG', N'Hong Kong', N'HKG', 344, 852)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (97, N'HU', N'HUNGARY', N'Hungary', N'HUN', 348, 36)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (98, N'IS', N'ICELAND', N'Iceland', N'ISL', 352, 354)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (99, N'IN', N'INDIA', N'India', N'IND', 356, 91)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (100, N'ID', N'INDONESIA', N'Indonesia', N'IDN', 360, 62)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (101, N'IR', N'IRAN, ISLAMIC REPUBLIC OF', N'Iran, Islamic Republic of', N'IRN', 364, 98)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (102, N'IQ', N'IRAQ', N'Iraq', N'IRQ', 368, 964)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (103, N'IE', N'IRELAND', N'Ireland', N'IRL', 372, 353)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (104, N'IL', N'ISRAEL', N'Israel', N'ISR', 376, 972)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (105, N'IT', N'ITALY', N'Italy', N'ITA', 380, 39)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (106, N'JM', N'JAMAICA', N'Jamaica', N'JAM', 388, 1876)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (107, N'JP', N'JAPAN', N'Japan', N'JPN', 392, 81)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (108, N'JO', N'JORDAN', N'Jordan', N'JOR', 400, 962)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (109, N'KZ', N'KAZAKHSTAN', N'Kazakhstan', N'KAZ', 398, 7)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (110, N'KE', N'KENYA', N'Kenya', N'KEN', 404, 254)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (111, N'KI', N'KIRIBATI', N'Kiribati', N'KIR', 296, 686)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (112, N'KP', N'KOREA, DEMOCRATIC PEOPLE''S REPUBLIC OF', N'Korea, Democratic People''s Republic of', N'PRK', 408, 850)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (113, N'KR', N'KOREA, REPUBLIC OF', N'Korea, Republic of', N'KOR', 410, 82)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (114, N'KW', N'KUWAIT', N'Kuwait', N'KWT', 414, 965)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (115, N'KG', N'KYRGYZSTAN', N'Kyrgyzstan', N'KGZ', 417, 996)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (116, N'LA', N'LAO PEOPLE''S DEMOCRATIC REPUBLIC', N'Lao People''s Democratic Republic', N'LAO', 418, 856)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (117, N'LV', N'LATVIA', N'Latvia', N'LVA', 428, 371)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (118, N'LB', N'LEBANON', N'Lebanon', N'LBN', 422, 961)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (119, N'LS', N'LESOTHO', N'Lesotho', N'LSO', 426, 266)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (120, N'LR', N'LIBERIA', N'Liberia', N'LBR', 430, 231)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (121, N'LY', N'LIBYAN ARAB JAMAHIRIYA', N'Libyan Arab Jamahiriya', N'LBY', 434, 218)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (122, N'LI', N'LIECHTENSTEIN', N'Liechtenstein', N'LIE', 438, 423)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (123, N'LT', N'LITHUANIA', N'Lithuania', N'LTU', 440, 370)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (124, N'LU', N'LUXEMBOURG', N'Luxembourg', N'LUX', 442, 352)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (125, N'MO', N'MACAO', N'Macao', N'MAC', 446, 853)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (126, N'MK', N'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF', N'Macedonia, the Former Yugoslav Republic of', N'MKD', 807, 389)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (127, N'MG', N'MADAGASCAR', N'Madagascar', N'MDG', 450, 261)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (128, N'MW', N'MALAWI', N'Malawi', N'MWI', 454, 265)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (129, N'MY', N'MALAYSIA', N'Malaysia', N'MYS', 458, 60)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (130, N'MV', N'MALDIVES', N'Maldives', N'MDV', 462, 960)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (131, N'ML', N'MALI', N'Mali', N'MLI', 466, 223)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (132, N'MT', N'MALTA', N'Malta', N'MLT', 470, 356)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (133, N'MH', N'MARSHALL ISLANDS', N'Marshall Islands', N'MHL', 584, 692)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (134, N'MQ', N'MARTINIQUE', N'Martinique', N'MTQ', 474, 596)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (135, N'MR', N'MAURITANIA', N'Mauritania', N'MRT', 478, 222)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (136, N'MU', N'MAURITIUS', N'Mauritius', N'MUS', 480, 230)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (137, N'YT', N'MAYOTTE', N'Mayotte', NULL, NULL, 269)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (138, N'MX', N'MEXICO', N'Mexico', N'MEX', 484, 52)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (139, N'FM', N'MICRONESIA, FEDERATED STATES OF', N'Micronesia, Federated States of', N'FSM', 583, 691)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (140, N'MD', N'MOLDOVA, REPUBLIC OF', N'Moldova, Republic of', N'MDA', 498, 373)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (141, N'MC', N'MONACO', N'Monaco', N'MCO', 492, 377)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (142, N'MN', N'MONGOLIA', N'Mongolia', N'MNG', 496, 976)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (143, N'MS', N'MONTSERRAT', N'Montserrat', N'MSR', 500, 1664)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (144, N'MA', N'MOROCCO', N'Morocco', N'MAR', 504, 212)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (145, N'MZ', N'MOZAMBIQUE', N'Mozambique', N'MOZ', 508, 258)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (146, N'MM', N'MYANMAR', N'Myanmar', N'MMR', 104, 95)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (147, N'NA', N'NAMIBIA', N'Namibia', N'NAM', 516, 264)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (148, N'NR', N'NAURU', N'Nauru', N'NRU', 520, 674)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (149, N'NP', N'NEPAL', N'Nepal', N'NPL', 524, 977)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (150, N'NL', N'NETHERLANDS', N'Netherlands', N'NLD', 528, 31)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (151, N'AN', N'NETHERLANDS ANTILLES', N'Netherlands Antilles', N'ANT', 530, 599)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (152, N'NC', N'NEW CALEDONIA', N'New Caledonia', N'NCL', 540, 687)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (153, N'NZ', N'NEW ZEALAND', N'New Zealand', N'NZL', 554, 64)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (154, N'NI', N'NICARAGUA', N'Nicaragua', N'NIC', 558, 505)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (155, N'NE', N'NIGER', N'Niger', N'NER', 562, 227)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (156, N'NG', N'NIGERIA', N'Nigeria', N'NGA', 566, 234)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (157, N'NU', N'NIUE', N'Niue', N'NIU', 570, 683)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (158, N'NF', N'NORFOLK ISLAND', N'Norfolk Island', N'NFK', 574, 672)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (159, N'MP', N'NORTHERN MARIANA ISLANDS', N'Northern Mariana Islands', N'MNP', 580, 1670)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (160, N'NO', N'NORWAY', N'Norway', N'NOR', 578, 47)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (161, N'OM', N'OMAN', N'Oman', N'OMN', 512, 968)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (162, N'PK', N'PAKISTAN', N'Pakistan', N'PAK', 586, 92)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (163, N'PW', N'PALAU', N'Palau', N'PLW', 585, 680)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (164, N'PS', N'PALESTINIAN TERRITORY, OCCUPIED', N'Palestinian Territory, Occupied', NULL, NULL, 970)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (165, N'PA', N'PANAMA', N'Panama', N'PAN', 591, 507)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (166, N'PG', N'PAPUA NEW GUINEA', N'Papua New Guinea', N'PNG', 598, 675)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (167, N'PY', N'PARAGUAY', N'Paraguay', N'PRY', 600, 595)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (168, N'PE', N'PERU', N'Peru', N'PER', 604, 51)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (169, N'PH', N'PHILIPPINES', N'Philippines', N'PHL', 608, 63)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (170, N'PN', N'PITCAIRN', N'Pitcairn', N'PCN', 612, 0)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (171, N'PL', N'POLAND', N'Poland', N'POL', 616, 48)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (172, N'PT', N'PORTUGAL', N'Portugal', N'PRT', 620, 351)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (173, N'PR', N'PUERTO RICO', N'Puerto Rico', N'PRI', 630, 1787)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (174, N'QA', N'QATAR', N'Qatar', N'QAT', 634, 974)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (175, N'RE', N'REUNION', N'Reunion', N'REU', 638, 262)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (176, N'RO', N'ROMANIA', N'Romania', N'ROM', 642, 40)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (177, N'RU', N'RUSSIAN FEDERATION', N'Russian Federation', N'RUS', 643, 70)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (178, N'RW', N'RWANDA', N'Rwanda', N'RWA', 646, 250)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (179, N'SH', N'SAINT HELENA', N'Saint Helena', N'SHN', 654, 290)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (180, N'KN', N'SAINT KITTS AND NEVIS', N'Saint Kitts and Nevis', N'KNA', 659, 1869)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (181, N'LC', N'SAINT LUCIA', N'Saint Lucia', N'LCA', 662, 1758)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (182, N'PM', N'SAINT PIERRE AND MIQUELON', N'Saint Pierre and Miquelon', N'SPM', 666, 508)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (183, N'VC', N'SAINT VINCENT AND THE GRENADINES', N'Saint Vincent and the Grenadines', N'VCT', 670, 1784)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (184, N'WS', N'SAMOA', N'Samoa', N'WSM', 882, 684)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (185, N'SM', N'SAN MARINO', N'San Marino', N'SMR', 674, 378)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (186, N'ST', N'SAO TOME AND PRINCIPE', N'Sao Tome and Principe', N'STP', 678, 239)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (187, N'SA', N'SAUDI ARABIA', N'Saudi Arabia', N'SAU', 682, 966)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (188, N'SN', N'SENEGAL', N'Senegal', N'SEN', 686, 221)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (189, N'CS', N'SERBIA AND MONTENEGRO', N'Serbia and Montenegro', NULL, NULL, 381)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (190, N'SC', N'SEYCHELLES', N'Seychelles', N'SYC', 690, 248)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (191, N'SL', N'SIERRA LEONE', N'Sierra Leone', N'SLE', 694, 232)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (192, N'SG', N'SINGAPORE', N'Singapore', N'SGP', 702, 65)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (193, N'SK', N'SLOVAKIA', N'Slovakia', N'SVK', 703, 421)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (194, N'SI', N'SLOVENIA', N'Slovenia', N'SVN', 705, 386)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (195, N'SB', N'SOLOMON ISLANDS', N'Solomon Islands', N'SLB', 90, 677)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (196, N'SO', N'SOMALIA', N'Somalia', N'SOM', 706, 252)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (197, N'ZA', N'SOUTH AFRICA', N'South Africa', N'ZAF', 710, 27)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (198, N'GS', N'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', N'South Georgia and the South Sandwich Islands', NULL, NULL, 0)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (199, N'ES', N'SPAIN', N'Spain', N'ESP', 724, 34)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (200, N'LK', N'SRI LANKA', N'Sri Lanka', N'LKA', 144, 94)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (201, N'SD', N'SUDAN', N'Sudan', N'SDN', 736, 249)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (202, N'SR', N'SURINAME', N'Suriname', N'SUR', 740, 597)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (203, N'SJ', N'SVALBARD AND JAN MAYEN', N'Svalbard and Jan Mayen', N'SJM', 744, 47)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (204, N'SZ', N'SWAZILAND', N'Swaziland', N'SWZ', 748, 268)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (205, N'SE', N'SWEDEN', N'Sweden', N'SWE', 752, 46)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (206, N'CH', N'SWITZERLAND', N'Switzerland', N'CHE', 756, 41)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (207, N'SY', N'SYRIAN ARAB REPUBLIC', N'Syrian Arab Republic', N'SYR', 760, 963)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (208, N'TW', N'TAIWAN, PROVINCE OF CHINA', N'Taiwan, Province of China', N'TWN', 158, 886)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (209, N'TJ', N'TAJIKISTAN', N'Tajikistan', N'TJK', 762, 992)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (210, N'TZ', N'TANZANIA, UNITED REPUBLIC OF', N'Tanzania, United Republic of', N'TZA', 834, 255)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (211, N'TH', N'THAILAND', N'Thailand', N'THA', 764, 66)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (212, N'TL', N'TIMOR-LESTE', N'Timor-Leste', NULL, NULL, 670)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (213, N'TG', N'TOGO', N'Togo', N'TGO', 768, 228)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (214, N'TK', N'TOKELAU', N'Tokelau', N'TKL', 772, 690)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (215, N'TO', N'TONGA', N'Tonga', N'TON', 776, 676)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (216, N'TT', N'TRINIDAD AND TOBAGO', N'Trinidad and Tobago', N'TTO', 780, 1868)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (217, N'TN', N'TUNISIA', N'Tunisia', N'TUN', 788, 216)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (218, N'TR', N'TURKEY', N'Turkey', N'TUR', 792, 90)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (219, N'TM', N'TURKMENISTAN', N'Turkmenistan', N'TKM', 795, 7370)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (220, N'TC', N'TURKS AND CAICOS ISLANDS', N'Turks and Caicos Islands', N'TCA', 796, 1649)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (221, N'TV', N'TUVALU', N'Tuvalu', N'TUV', 798, 688)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (222, N'UG', N'UGANDA', N'Uganda', N'UGA', 800, 256)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (223, N'UA', N'UKRAINE', N'Ukraine', N'UKR', 804, 380)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (224, N'AE', N'UNITED ARAB EMIRATES', N'United Arab Emirates', N'ARE', 784, 971)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (225, N'GB', N'UNITED KINGDOM', N'United Kingdom', N'GBR', 826, 44)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (226, N'US', N'UNITED STATES', N'United States', N'USA', 840, 1)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (227, N'UM', N'UNITED STATES MINOR OUTLYING ISLANDS', N'United States Minor Outlying Islands', NULL, NULL, 1)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (228, N'UY', N'URUGUAY', N'Uruguay', N'URY', 858, 598)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (229, N'UZ', N'UZBEKISTAN', N'Uzbekistan', N'UZB', 860, 998)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (230, N'VU', N'VANUATU', N'Vanuatu', N'VUT', 548, 678)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (231, N'VE', N'VENEZUELA', N'Venezuela', N'VEN', 862, 58)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (232, N'VN', N'VIET NAM', N'Viet Nam', N'VNM', 704, 84)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (233, N'VG', N'VIRGIN ISLANDS, BRITISH', N'Virgin Islands, British', N'VGB', 92, 1284)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (234, N'VI', N'VIRGIN ISLANDS, U.S.', N'Virgin Islands, U.s.', N'VIR', 850, 1340)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (235, N'WF', N'WALLIS AND FUTUNA', N'Wallis and Futuna', N'WLF', 876, 681)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (236, N'EH', N'WESTERN SAHARA', N'Western Sahara', N'ESH', 732, 212)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (237, N'YE', N'YEMEN', N'Yemen', N'YEM', 887, 967)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (238, N'ZM', N'ZAMBIA', N'Zambia', N'ZMB', 894, 260)
GO
INSERT [dbo].[Country] ([Id], [iso], [name], [nicename], [iso3], [numcode], [phonecode]) VALUES (239, N'ZW', N'ZIMBABWE', N'Zimbabwe', N'ZWE', 716, 263)
GO
SET IDENTITY_INSERT [dbo].[Country] OFF
GO
SET IDENTITY_INSERT [dbo].[Dealer_SalesPartner] ON 

GO
INSERT [dbo].[Dealer_SalesPartner] ([id], [serialCode], [firstName], [lastName], [address1], [address2], [city], [stateId], [countryId], [region], [zipCode], [primaryPhoneNo], [mobilePhoneNo], [routingNo], [accountNo], [email], [userType], [joinDate], [commissionRate], [createDate]) VALUES (1, N'100001', N'Aminul', N'Islam', N'809 N Bethlehem Pike', N'', N'Ambler', N'PA', NULL, NULL, N'19002', N'8801816027706', N'8801816027706', N'031918873', N'152132', N'dealer1@etag365.com', 3, CAST(0x0000AB7F00000000 AS DateTime), CAST(10.00 AS Decimal(10, 2)), CAST(0x0000AC2800EE2FCF AS DateTime))
GO
INSERT [dbo].[Dealer_SalesPartner] ([id], [serialCode], [firstName], [lastName], [address1], [address2], [city], [stateId], [countryId], [region], [zipCode], [primaryPhoneNo], [mobilePhoneNo], [routingNo], [accountNo], [email], [userType], [joinDate], [commissionRate], [createDate]) VALUES (8, N'100002', N'Test', N'Dealer2', N'test', N'', N'test', N'AL', NULL, NULL, N'19001', N'8801816027708', N'8801816027708', N'', N'', N'dealer2@etag365.com', 3, CAST(0x0000AB8B00000000 AS DateTime), CAST(10.00 AS Decimal(10, 2)), CAST(0x0000ABD1016EABF1 AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Dealer_SalesPartner] OFF
GO
SET IDENTITY_INSERT [dbo].[Dealer_SalesPartner_DetailsZipCodeCoverage] ON 

GO
INSERT [dbo].[Dealer_SalesPartner_DetailsZipCodeCoverage] ([id], [dealerSalesPartnerId], [zipCode], [commissionRate]) VALUES (1, N'100001', N'19034', CAST(10.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[Dealer_SalesPartner_DetailsZipCodeCoverage] ([id], [dealerSalesPartnerId], [zipCode], [commissionRate]) VALUES (3, N'100002', N'19001', CAST(10.00 AS Decimal(10, 2)))
GO
SET IDENTITY_INSERT [dbo].[Dealer_SalesPartner_DetailsZipCodeCoverage] OFF
GO
SET IDENTITY_INSERT [dbo].[EmailLog] ON 

GO
INSERT [dbo].[EmailLog] ([Id], [PersonEmail], [FromEmail], [EmailNumber], [EmailSentOn], [Status], [TemplateId]) VALUES (1, N'aftabudduza@gmail.com', N'aftab@2rsolution.com', 0, CAST(0x0000ACA00147A5B5 AS DateTime), N'Success', N'1')
GO
INSERT [dbo].[EmailLog] ([Id], [PersonEmail], [FromEmail], [EmailNumber], [EmailSentOn], [Status], [TemplateId]) VALUES (2, N'aftab@2rsolution.com', N'aftab@2rsolution.com', 0, CAST(0x0000ACA00147BC6C AS DateTime), N'Success', N'1')
GO
SET IDENTITY_INSERT [dbo].[EmailLog] OFF
GO
SET IDENTITY_INSERT [dbo].[EmailSchedule] ON 

GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (5, N'1033', N'sbutcher@myfileit.com', N'aftabudduza@gmail.com', 0, N'1', NULL, NULL, 2, NULL, N'8801817708660', CAST(0x0000ACFE00E9E766 AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (6, N'1032', N'aftab@2rsolution.com', N'aftabudduza@gmail.com', 0, N'1', NULL, NULL, 2, NULL, N'8801817708660', CAST(0x0000ACFE00E9E769 AS DateTime), N'8801817708660', CAST(0x0000AD0600D2A015 AS DateTime), N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (7, N'1034', N'abc@a.com', N'aftabudduza@gmail.com', 0, N'1', NULL, NULL, 2, NULL, N'8801817708660', CAST(0x0000ACFE00E9E771 AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (8, N'1026', N'skbutcher@myfileit.com', N'aftabudduza@gmail.com', 0, N'7', NULL, NULL, 0, NULL, N'8801817708660', CAST(0x0000ACFE00EB5C8D AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (9, N'1026', N'skbutcher@myfileit.com', N'aftabudduza@gmail.com', 0, N'7', NULL, NULL, 1, NULL, N'8801817708660', CAST(0x0000ACFE00EB5C8E AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (10, N'1026', N'skbutcher@myfileit.com', N'aftabudduza@gmail.com', 0, N'7', NULL, NULL, 2, NULL, N'8801817708660', CAST(0x0000ACFE00EB5C8E AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (11, N'1032', N'aftab@2rsolution.com', N'aftabudduza@gmail.com', 0, N'2', NULL, NULL, 0, NULL, N'8801817708660', CAST(0x0000AD0600D29FFD AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (12, N'1032', N'aftab@2rsolution.com', N'aftabudduza@gmail.com', 0, N'2', NULL, NULL, 1, NULL, N'8801817708660', CAST(0x0000AD0600D2A015 AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1011, N'1034', N'abc@a.com', N'abc@adi.com', 0, N'2', NULL, NULL, 0, NULL, N'8801817708660', CAST(0x0000AD22018AA96B AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1012, N'1034', N'abc@a.com', N'abc@adi.com', 0, N'2', NULL, NULL, 1, NULL, N'8801817708660', CAST(0x0000AD22018AA96B AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1013, N'1034', N'abc@a.com', N'abc@adi.com', 0, N'2', NULL, NULL, 2, NULL, N'8801817708660', CAST(0x0000AD22018AA96B AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1014, N'1032', N'aftab@2rsolution.com', N'abc@adi.com', 0, N'2', NULL, NULL, 0, NULL, N'8801817708660', CAST(0x0000AD23000B6A4E AS DateTime), N'8801817708660', CAST(0x0000AD23000BA332 AS DateTime), N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1015, N'1032', N'aftab@2rsolution.com', N'abc@adi.com', 0, N'2', NULL, NULL, 1, NULL, N'8801817708660', CAST(0x0000AD23000B6A4E AS DateTime), N'8801817708660', CAST(0x0000AD23000BA332 AS DateTime), N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1016, N'1032', N'aftab@2rsolution.com', N'abc@adi.com', 0, N'2', NULL, NULL, 2, NULL, N'8801817708660', CAST(0x0000AD23000B6A4E AS DateTime), N'8801817708660', CAST(0x0000AD23000BA332 AS DateTime), N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1017, N'1040', N'a@a.com', N'abc@adi.com', 0, N'2', NULL, NULL, 0, NULL, N'8801817708660', CAST(0x0000AD230111BD52 AS DateTime), N'8801817708660', CAST(0x0000AD23011655F4 AS DateTime), N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1018, N'1040', N'a@a.com', N'abc@adi.com', 0, N'2', NULL, NULL, 1, NULL, N'8801817708660', CAST(0x0000AD230111BD52 AS DateTime), N'8801817708660', CAST(0x0000AD23011655F4 AS DateTime), N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1019, N'1040', N'a@a.com', N'abc@adi.com', 0, N'2', NULL, NULL, 2, NULL, N'8801817708660', CAST(0x0000AD230111BD52 AS DateTime), N'8801817708660', CAST(0x0000AD23011655F4 AS DateTime), N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1020, N'1033', N'sbutcher@myfileit.com', N'abc@adi.com', 0, N'2', NULL, NULL, 0, NULL, N'8801817708660', CAST(0x0000AD230142F843 AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1021, N'1033', N'sbutcher@myfileit.com', N'abc@adi.com', 0, N'2', NULL, NULL, 1, NULL, N'8801817708660', CAST(0x0000AD230142F843 AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1022, N'1033', N'sbutcher@myfileit.com', N'abc@adi.com', 0, N'2', NULL, NULL, 2, NULL, N'8801817708660', CAST(0x0000AD230142F843 AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1023, N'1041', N'a@a.com', N'aftab@2rsolution.com', 0, N'2', NULL, NULL, 0, NULL, N'8801817708660', CAST(0x0000AE1B001BA27C AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1024, N'1041', N'a@a.com', N'aftab@2rsolution.com', 0, N'2', NULL, NULL, 1, NULL, N'8801817708660', CAST(0x0000AE1B001BA27D AS DateTime), NULL, NULL, N'Category1', N'')
GO
INSERT [dbo].[EmailSchedule] ([Id], [PersonName], [PersonEmail], [FromEmail], [IsLoop], [Days], [IsZeroMailSent], [ZeroEmailSentOn], [LastEmailNumber], [LastEmailSentOn], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Category], [Type]) VALUES (1025, N'1041', N'a@a.com', N'aftab@2rsolution.com', 0, N'2', NULL, NULL, 2, NULL, N'8801817708660', CAST(0x0000AE1B001BA27D AS DateTime), NULL, NULL, N'Category1', N'')
GO
SET IDENTITY_INSERT [dbo].[EmailSchedule] OFF
GO
SET IDENTITY_INSERT [dbo].[EmailSetup] ON 

GO
INSERT [dbo].[EmailSetup] ([Id], [UserId], [TemplateNo], [Category], [Type], [Subject], [Content], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Greetings]) VALUES (1, N'1', N'0', N'Category1', N'', N'zero', N'<p>zero content</p>', N'8801817708660', CAST(0x0000AC9501708836 AS DateTime), N'8801817708660', CAST(0x0000ACFE00C8198E AS DateTime), N'Hi')
GO
INSERT [dbo].[EmailSetup] ([Id], [UserId], [TemplateNo], [Category], [Type], [Subject], [Content], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Greetings]) VALUES (2, N'1', N'1', N'Category1', N'', N'Template one ', N'<p><span style="color: #b96ad9;">Template&nbsp;One Content</span></p>', N'8801817708660', CAST(0x0000AC950173FA77 AS DateTime), N'8801817708660', CAST(0x0000ACFE00C8396C AS DateTime), N'Hi')
GO
INSERT [dbo].[EmailSetup] ([Id], [UserId], [TemplateNo], [Category], [Type], [Subject], [Content], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Greetings]) VALUES (3, N'1', N'2', N'Category1', N'', N'two', N'<p>two contents.</p>', N'8801817708660', CAST(0x0000AC950173FA77 AS DateTime), N'8801817708660', CAST(0x0000ACFE00C8291D AS DateTime), N'Hi')
GO
INSERT [dbo].[EmailSetup] ([Id], [UserId], [TemplateNo], [Category], [Type], [Subject], [Content], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Greetings]) VALUES (4, N'1', N'2', N'Category2', N'', N'two sub', N'<p>sub-category 2</p>', N'8801817708660', CAST(0x0000ACD300E897A8 AS DateTime), NULL, NULL, N'Hi')
GO
SET IDENTITY_INSERT [dbo].[EmailSetup] OFF
GO
SET IDENTITY_INSERT [dbo].[EmailUnsubscribe] ON 

GO
INSERT [dbo].[EmailUnsubscribe] ([Id], [TemplateNo], [UserId], [TemplateId]) VALUES (1, N'0', N'2', N'1')
GO
SET IDENTITY_INSERT [dbo].[EmailUnsubscribe] OFF
GO
SET IDENTITY_INSERT [dbo].[FinancialTransaction] ON 

GO
INSERT [dbo].[FinancialTransaction] ([Id], [Serial], [AccountType], [LedgerCode], [InvoiceNo], [RefId], [Amount], [Debit], [Credit], [CreateDate], [Remarks], [EntryType]) VALUES (3, N'F00000000001', N'Asset', N'1010', N'I00000000001', N'8801817708660', 11.8800, 11.8800, 0.0000, CAST(0x0000ABB7000C9371 AS DateTime), N'SubscriptionFee', N'Debit')
GO
INSERT [dbo].[FinancialTransaction] ([Id], [Serial], [AccountType], [LedgerCode], [InvoiceNo], [RefId], [Amount], [Debit], [Credit], [CreateDate], [Remarks], [EntryType]) VALUES (4, N'F00000000001', N'Inc', N'4060', N'I00000000001', N'8801817708660', 11.8800, 0.0000, 11.8800, CAST(0x0000ABB7000C97BA AS DateTime), N'SubscriptionFee', N'Credit')
GO
INSERT [dbo].[FinancialTransaction] ([Id], [Serial], [AccountType], [LedgerCode], [InvoiceNo], [RefId], [Amount], [Debit], [Credit], [CreateDate], [Remarks], [EntryType]) VALUES (7, N'F00000000002', N'Asset', N'1010', N'I00000000002', N'8801817708661', 11.8800, 11.8800, 0.0000, CAST(0x0000ABB700F05FE3 AS DateTime), N'SubscriptionFee', N'Debit')
GO
INSERT [dbo].[FinancialTransaction] ([Id], [Serial], [AccountType], [LedgerCode], [InvoiceNo], [RefId], [Amount], [Debit], [Credit], [CreateDate], [Remarks], [EntryType]) VALUES (8, N'F00000000002', N'Inc', N'4060', N'I00000000002', N'8801817708661', 11.8800, 0.0000, 11.8800, CAST(0x0000ABB700F0608A AS DateTime), N'SubscriptionFee', N'Credit')
GO
INSERT [dbo].[FinancialTransaction] ([Id], [Serial], [AccountType], [LedgerCode], [InvoiceNo], [RefId], [Amount], [Debit], [Credit], [CreateDate], [Remarks], [EntryType]) VALUES (10009, N'F00000000003', N'Liab', N'4010', N'I00000000006', N'8801817708660', 0.0100, 0.0100, 0.0000, CAST(0x0000ABE6017572BD AS DateTime), N'User Commission', N'Debit')
GO
INSERT [dbo].[FinancialTransaction] ([Id], [Serial], [AccountType], [LedgerCode], [InvoiceNo], [RefId], [Amount], [Debit], [Credit], [CreateDate], [Remarks], [EntryType]) VALUES (10010, N'F00000000003', N'Asset', N'1010', N'I00000000006', N'8801817708660', 0.0100, 0.0000, 0.0100, CAST(0x0000ABE6017572BD AS DateTime), N'User Commission', N'Credit')
GO
SET IDENTITY_INSERT [dbo].[FinancialTransaction] OFF
GO
INSERT [dbo].[GlobalID] ([ObjectID], [ItemID], [IDForYear], [IDForMonth], [IDForDate], [CurrentID]) VALUES (N'User', N'Id', 2020, NULL, NULL, 23)
GO
INSERT [dbo].[GlobalID] ([ObjectID], [ItemID], [IDForYear], [IDForMonth], [IDForDate], [CurrentID]) VALUES (N'Dealer', N'Id', 2020, NULL, NULL, 3)
GO
INSERT [dbo].[GlobalID] ([ObjectID], [ItemID], [IDForYear], [IDForMonth], [IDForDate], [CurrentID]) VALUES (N'Billing', N'Id', 2020, NULL, NULL, 11)
GO
INSERT [dbo].[GlobalID] ([ObjectID], [ItemID], [IDForYear], [IDForMonth], [IDForDate], [CurrentID]) VALUES (N'Account', N'Id', 2020, NULL, NULL, 3)
GO
SET IDENTITY_INSERT [dbo].[GroupCode] ON 

GO
INSERT [dbo].[GroupCode] ([Id], [GroupCodeNo], [GroupName], [GroupDescription], [GroupPlan], [Amount], [BillEvery], [IsForever], [StartDate], [EndDate], [IsRequiredACHInfo], [CreditPhoneNo], [Rewards], [GroupCodeFor], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate]) VALUES (1, N'G0002', N'100% Off on Gold Plan', N'100% Off on Gold Plan', N'Gold', CAST(110.00 AS Decimal(18, 2)), N'Yearly', 0, CAST(0x0000ABAE00000000 AS DateTime), CAST(0x0000AEA600000000 AS DateTime), 1, N'2156691499', CAST(0.00 AS Decimal(18, 2)), N'User', NULL, NULL, N'8801817708660', CAST(0x0000ABC001193042 AS DateTime), NULL, NULL)
GO
INSERT [dbo].[GroupCode] ([Id], [GroupCodeNo], [GroupName], [GroupDescription], [GroupPlan], [Amount], [BillEvery], [IsForever], [StartDate], [EndDate], [IsRequiredACHInfo], [CreditPhoneNo], [Rewards], [GroupCodeFor], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate]) VALUES (2, N'G0003', N'Silver', N'Silver', N'Silver', CAST(10.00 AS Decimal(18, 2)), N'Yearly', 0, CAST(0x0000AB9000000000 AS DateTime), CAST(0x0000AB9400000000 AS DateTime), 1, N'8801816027706', CAST(5.00 AS Decimal(18, 2)), N'Dealer', NULL, NULL, N'8801817708660', CAST(0x0000AB900024BF94 AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[GroupCode] OFF
GO
SET IDENTITY_INSERT [dbo].[ImportContact] ON 

GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (5, 1, 0, 1, 0, 1, CAST(0x0000ABA00018E485 AS DateTime), N'1', CAST(0x0000ABA00018E485 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (6, 1, 0, 1, 0, 1, CAST(0x0000ABA00019AB27 AS DateTime), N'1', CAST(0x0000ABA00019AB27 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (8, 1, 1, 0, 1, 0, CAST(0x0000ABA0011C8C19 AS DateTime), N'8801817708660', CAST(0x0000ABA0011C8C19 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (9, 1, 1, 0, 0, 0, CAST(0x0000ABA0013D2F47 AS DateTime), N'8801817708660', CAST(0x0000ABA0013D2F47 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (10, 1, 1, 0, 1, 0, CAST(0x0000ABA001460DB8 AS DateTime), N'8801817708660', CAST(0x0000ABA001460DB8 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (11, 1, 0, 1, 0, 1, CAST(0x0000ABA0014755D6 AS DateTime), N'8801817708660', CAST(0x0000ABA0014755D6 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (12, 1, 0, 1, 0, 1, CAST(0x0000ABA00148812E AS DateTime), N'8801817708660', CAST(0x0000ABA00148812E AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (13, 1, 1, 0, 1, 0, CAST(0x0000ABA0016DEDC1 AS DateTime), N'8801817708660', CAST(0x0000ABA0016DEDC1 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (14, 1, 1, 0, 0, 0, CAST(0x0000ABA00173AA9F AS DateTime), N'8801817708660', CAST(0x0000ABA00173AA9F AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (15, 2, 0, 1, 0, 1, CAST(0x0000ABF5000B19EA AS DateTime), N'8801817708661', CAST(0x0000ABF5000B19EA AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (16, 2, 0, 1, 0, 1, CAST(0x0000ABF5000B2073 AS DateTime), N'8801817708661', CAST(0x0000ABF5000B2073 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (17, 1, 0, 1, 0, 1, CAST(0x0000ACD1001329EE AS DateTime), N'8801817708660', CAST(0x0000ACD1001329EE AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (18, 1, 0, 1, 0, 1, CAST(0x0000ACD10013337F AS DateTime), N'8801817708660', CAST(0x0000ACD10013337F AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (19, 1, 1, 0, 1, 0, CAST(0x0000ACD100135B3A AS DateTime), N'8801817708660', CAST(0x0000ACD100135B3A AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (20, 1, 0, 1, 0, 1, CAST(0x0000ACD10013CC57 AS DateTime), N'8801817708660', CAST(0x0000ACD10013CC57 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (21, 1, 0, 1, 0, 1, CAST(0x0000ACDF000B2182 AS DateTime), N'8801817708660', CAST(0x0000ACDF000B2182 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (22, 1, 0, 1, 0, 1, CAST(0x0000ACDF000B5BEB AS DateTime), N'8801817708660', CAST(0x0000ACDF000B5BEB AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (1017, 1, 0, 1, 0, 1, CAST(0x0000ACE500163CDF AS DateTime), N'8801817708660', CAST(0x0000ACE500163CDF AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (1018, 1, 0, 1, 0, 1, CAST(0x0000ACE5001AC1DD AS DateTime), N'8801817708660', CAST(0x0000ACE5001AC1DD AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (1019, 1, 1, 0, 1, 0, CAST(0x0000ACFB01180168 AS DateTime), N'8801817708660', CAST(0x0000ACFB01180168 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (1020, 1, 0, 1, 0, 1, CAST(0x0000ACFB01183801 AS DateTime), N'8801817708660', CAST(0x0000ACFB01183801 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (1021, 1, 0, 1, 0, 1, CAST(0x0000ACFB01184896 AS DateTime), N'8801817708660', CAST(0x0000ACFB01184896 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (1022, 1, 0, 1, 0, 1, CAST(0x0000AD23010BA548 AS DateTime), N'8801817708660', CAST(0x0000AD23010BA548 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (1023, 1, 0, 1, 0, 1, CAST(0x0000AD23010BC499 AS DateTime), N'8801817708660', CAST(0x0000AD23010BC499 AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (1024, 1, 1, 0, 1, 0, CAST(0x0000AD230111BD5C AS DateTime), N'8801817708660', CAST(0x0000AD230111BD5C AS DateTime))
GO
INSERT [dbo].[ImportContact] ([Id], [UserId], [IsImport], [IsExport], [NoOfImport], [NoOfExport], [TranDate], [CreatedBy], [CreatedDate]) VALUES (1025, 1, 1, 0, 1, 0, CAST(0x0000AE1B001BA27D AS DateTime), N'8801817708660', CAST(0x0000AE1B001BA27D AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[ImportContact] OFF
GO
SET IDENTITY_INSERT [dbo].[Master] ON 

GO
INSERT [dbo].[Master] ([Id], [UserDefinedId], [Code], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (1, 1, N'01', N'Country', 1, CAST(0x0000A87900000000 AS DateTime), 1, CAST(0x0000A87900000000 AS DateTime))
GO
INSERT [dbo].[Master] ([Id], [UserDefinedId], [Code], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (2, 2, N'02', N'Currency', 1, CAST(0x0000A87900000000 AS DateTime), 1, CAST(0x0000A87900000000 AS DateTime))
GO
INSERT [dbo].[Master] ([Id], [UserDefinedId], [Code], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (3, 3, N'03', N'State', 1, CAST(0x0000A87900000000 AS DateTime), 1, CAST(0x0000A87900000000 AS DateTime))
GO
INSERT [dbo].[Master] ([Id], [UserDefinedId], [Code], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (4, 4, N'04', N'Contact Type', 1, CAST(0x0000A87900000000 AS DateTime), 1, CAST(0x0000A87900000000 AS DateTime))
GO
INSERT [dbo].[Master] ([Id], [UserDefinedId], [Code], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (5, 5, N'05', N'No Order Reason', 1, CAST(0x0000A87900000000 AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Master] ([Id], [UserDefinedId], [Code], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (6, 6, N'06', N'Month', 1, CAST(0x0000A87900000000 AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Master] ([Id], [UserDefinedId], [Code], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (7, 7, N'07', N'Ledger Code', 1, CAST(0x0000A87900000000 AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Master] ([Id], [UserDefinedId], [Code], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (8, 8, N'08', N'Payment Mode', 1, CAST(0x0000A87900000000 AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Master] ([Id], [UserDefinedId], [Code], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (9, 9, N'09', N'Category', 1, CAST(0x0000A87900000000 AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Master] OFF
GO
SET IDENTITY_INSERT [dbo].[PaymentHistory] ON 

GO
INSERT [dbo].[PaymentHistory] ([Id], [FromUser], [ToUser], [FromUserType], [ToUserType], [AccountName], [Address], [Address1], [City], [State], [Zip], [CardNumber], [CVS], [Month], [Year], [LastFourDigitCard], [IsCheckingAccount], [RoutingNo], [AccountNo], [CheckNo], [AccountType], [CreateDate], [AuthorizationCode], [TransactionCode], [TransactionDescription], [Getway], [Status], [Serial], [TransactionType], [LedgerCode], [Remarks], [SubscriptionType], [IsStorageSubscription], [IsReceivedCommissions], [YTD_Commission], [MTD_Commission], [IsRecurring], [YTD_Contact_Export_Limit], [MTD_Contact_Import_Limit], [Contact_Storage_Limit], [IsBillingCycleMonthly], [BasicAmount], [StorageAmount], [SubTotalCharge], [Promocode], [DiscountPercentage], [Discount], [CheckingAccountProcessingFee], [GrossAmount], [NetAmount], [DebitAmount], [CreditAmount], [NoOfContact], [ContactMultiplier], [TotalContact], [PerUnitCharge], [MonthlyCharge], [IsAgree]) VALUES (1, N'8801817708660', N'eTag365', 1, 1, N'Aftab', N'100 North Street', N'', N'NYC', N'NY', N'19002', N'', N'', N'', N'', N'5678', 1, N'125008547', N'5678', N'', N'Check', CAST(0x0000ABB2016DDA5E AS DateTime), N'36315274', N'36315274', N'APPROVED', N'Billing Payment', N'complete', N'I00000000001', N'SubscriptionFee', N'4060', N'SubscriptionFee', N'Basic', 0, 1, N'0.594', N'0.0495', 1, N'250', N'10', N'500', 0, N'11.88', N'0', N'11.88', N'G0001', N'5', N'1', N'0', N'11.88', N'11.88', 0.0000, 11.8800, N'500', N'1', N'500', N'1', N'1', 1)
GO
INSERT [dbo].[PaymentHistory] ([Id], [FromUser], [ToUser], [FromUserType], [ToUserType], [AccountName], [Address], [Address1], [City], [State], [Zip], [CardNumber], [CVS], [Month], [Year], [LastFourDigitCard], [IsCheckingAccount], [RoutingNo], [AccountNo], [CheckNo], [AccountType], [CreateDate], [AuthorizationCode], [TransactionCode], [TransactionDescription], [Getway], [Status], [Serial], [TransactionType], [LedgerCode], [Remarks], [SubscriptionType], [IsStorageSubscription], [IsReceivedCommissions], [YTD_Commission], [MTD_Commission], [IsRecurring], [YTD_Contact_Export_Limit], [MTD_Contact_Import_Limit], [Contact_Storage_Limit], [IsBillingCycleMonthly], [BasicAmount], [StorageAmount], [SubTotalCharge], [Promocode], [DiscountPercentage], [Discount], [CheckingAccountProcessingFee], [GrossAmount], [NetAmount], [DebitAmount], [CreditAmount], [NoOfContact], [ContactMultiplier], [TotalContact], [PerUnitCharge], [MonthlyCharge], [IsAgree]) VALUES (2, N'8801817708661', N'eTag365', 2, 1, N'Joe Clean', N'150 Horse Rd', N'', N'Flourtown', N'PA', N'19002', N'', N'', N'', N'', N'5678', 1, N'125008547', N'5678', N'', N'Check', CAST(0x0000ABB6012F6F9E AS DateTime), N'36548614', N'b8be91d7-8f5d-4113-8bda-cc1602d13c2a', N'APPROVED', N'Billing Payment', N'complete', N'I00000000002', N'SubscriptionFee', N'4060', N'SubscriptionFee', N'Basic', 0, 1, N'0.594', N'0.0495', 1, N'250', N'10', N'500', 0, N'11.88', N'0.00', N'11.88', N'', N'', N'0.00', N'0', N'11.88', N'11.88', 0.0000, 11.8800, N'500 ', N'1', N'500', N'1.00 ', N'1.00', 1)
GO
INSERT [dbo].[PaymentHistory] ([Id], [FromUser], [ToUser], [FromUserType], [ToUserType], [AccountName], [Address], [Address1], [City], [State], [Zip], [CardNumber], [CVS], [Month], [Year], [LastFourDigitCard], [IsCheckingAccount], [RoutingNo], [AccountNo], [CheckNo], [AccountType], [CreateDate], [AuthorizationCode], [TransactionCode], [TransactionDescription], [Getway], [Status], [Serial], [TransactionType], [LedgerCode], [Remarks], [SubscriptionType], [IsStorageSubscription], [IsReceivedCommissions], [YTD_Commission], [MTD_Commission], [IsRecurring], [YTD_Contact_Export_Limit], [MTD_Contact_Import_Limit], [Contact_Storage_Limit], [IsBillingCycleMonthly], [BasicAmount], [StorageAmount], [SubTotalCharge], [Promocode], [DiscountPercentage], [Discount], [CheckingAccountProcessingFee], [GrossAmount], [NetAmount], [DebitAmount], [CreditAmount], [NoOfContact], [ContactMultiplier], [TotalContact], [PerUnitCharge], [MonthlyCharge], [IsAgree]) VALUES (5, N'8801817708661', N'eTag365', 2, 1, N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'', N'', N'', N'', CAST(0x0000ABC001219511 AS DateTime), N'', N'', N'', N'Billing Payment', N'complete', N'I00000000003', N'SubscriptionFee', N'4060', N'SubscriptionFee', N'Gold', 0, 1, N'0', N'0', 0, N'unlimited', N'unlimited', N'unlimited', 0, N'110.00', N'0.00', N'110.00', N'G0002', N'', N'110.00', N'0', N'0.00', N'0.00', 0.0000, 0.0000, N'', N'1', N'', N'0.00', N'0.00', 1)
GO
INSERT [dbo].[PaymentHistory] ([Id], [FromUser], [ToUser], [FromUserType], [ToUserType], [AccountName], [Address], [Address1], [City], [State], [Zip], [CardNumber], [CVS], [Month], [Year], [LastFourDigitCard], [IsCheckingAccount], [RoutingNo], [AccountNo], [CheckNo], [AccountType], [CreateDate], [AuthorizationCode], [TransactionCode], [TransactionDescription], [Getway], [Status], [Serial], [TransactionType], [LedgerCode], [Remarks], [SubscriptionType], [IsStorageSubscription], [IsReceivedCommissions], [YTD_Commission], [MTD_Commission], [IsRecurring], [YTD_Contact_Export_Limit], [MTD_Contact_Import_Limit], [Contact_Storage_Limit], [IsBillingCycleMonthly], [BasicAmount], [StorageAmount], [SubTotalCharge], [Promocode], [DiscountPercentage], [Discount], [CheckingAccountProcessingFee], [GrossAmount], [NetAmount], [DebitAmount], [CreditAmount], [NoOfContact], [ContactMultiplier], [TotalContact], [PerUnitCharge], [MonthlyCharge], [IsAgree]) VALUES (6, N'8801817708661', N'eTag365', 2, 1, N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'', N'', N'', N'', CAST(0x0000ABC001265400 AS DateTime), N'', N'', N'', N'Billing Payment', N'complete', N'I00000000004', N'SubscriptionFee', N'4060', N'SubscriptionFee', N'Gold', 0, 1, N'0', N'0', 0, N'unlimited', N'unlimited', N'unlimited', 0, N'110.00', N'0.00', N'110.00', N'G0002', N'', N'110.00', N'0', N'0.00', N'0.00', 0.0000, 0.0000, N'', N'1', N'', N'0.00', N'0.00', 1)
GO
INSERT [dbo].[PaymentHistory] ([Id], [FromUser], [ToUser], [FromUserType], [ToUserType], [AccountName], [Address], [Address1], [City], [State], [Zip], [CardNumber], [CVS], [Month], [Year], [LastFourDigitCard], [IsCheckingAccount], [RoutingNo], [AccountNo], [CheckNo], [AccountType], [CreateDate], [AuthorizationCode], [TransactionCode], [TransactionDescription], [Getway], [Status], [Serial], [TransactionType], [LedgerCode], [Remarks], [SubscriptionType], [IsStorageSubscription], [IsReceivedCommissions], [YTD_Commission], [MTD_Commission], [IsRecurring], [YTD_Contact_Export_Limit], [MTD_Contact_Import_Limit], [Contact_Storage_Limit], [IsBillingCycleMonthly], [BasicAmount], [StorageAmount], [SubTotalCharge], [Promocode], [DiscountPercentage], [Discount], [CheckingAccountProcessingFee], [GrossAmount], [NetAmount], [DebitAmount], [CreditAmount], [NoOfContact], [ContactMultiplier], [TotalContact], [PerUnitCharge], [MonthlyCharge], [IsAgree]) VALUES (7, N'8801817708661', N'eTag365', 2, 1, N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'', N'', N'', N'', CAST(0x0000ABC001288210 AS DateTime), N'', N'', N'', N'Billing Payment', N'complete', N'I00000000005', N'SubscriptionFee', N'4060', N'SubscriptionFee', N'Gold', 0, 1, N'0', N'0', 0, N'unlimited', N'unlimited', N'unlimited', 0, N'110.00', N'0.00', N'110.00', N'G0002', N'', N'110.00', N'0', N'0.00', N'0.00', 0.0000, 0.0000, N'', N'1', N'', N'0.00', N'0.00', 1)
GO
INSERT [dbo].[PaymentHistory] ([Id], [FromUser], [ToUser], [FromUserType], [ToUserType], [AccountName], [Address], [Address1], [City], [State], [Zip], [CardNumber], [CVS], [Month], [Year], [LastFourDigitCard], [IsCheckingAccount], [RoutingNo], [AccountNo], [CheckNo], [AccountType], [CreateDate], [AuthorizationCode], [TransactionCode], [TransactionDescription], [Getway], [Status], [Serial], [TransactionType], [LedgerCode], [Remarks], [SubscriptionType], [IsStorageSubscription], [IsReceivedCommissions], [YTD_Commission], [MTD_Commission], [IsRecurring], [YTD_Contact_Export_Limit], [MTD_Contact_Import_Limit], [Contact_Storage_Limit], [IsBillingCycleMonthly], [BasicAmount], [StorageAmount], [SubTotalCharge], [Promocode], [DiscountPercentage], [Discount], [CheckingAccountProcessingFee], [GrossAmount], [NetAmount], [DebitAmount], [CreditAmount], [NoOfContact], [ContactMultiplier], [TotalContact], [PerUnitCharge], [MonthlyCharge], [IsAgree]) VALUES (8, N'eTag365', N'8801817708660', 1, 2, N'Somers Butcher', N'809 N Bethlehem Pike', N'', N'Ambler', N'PA', N'19002', N'', N'', N'', N'', N'2132', 1, N'031918873', N'2132', N'', N'Check', CAST(0x0000ABE601730AA8 AS DateTime), N'', N'', N'', N'Commission', N'complete', N'I00000000006', N'Commission', N'4010', N'User Commission', N'', 0, 0, N'0', N'0', 0, N'0', N'0', N'0', 0, N'0.01', N'0', N'0.01', N'', N'', N'', N'', N'0.01', N'0.01', 0.0100, 0.0000, N'', N'', N'', N'', N'', 1)
GO
SET IDENTITY_INSERT [dbo].[PaymentHistory] OFF
GO
SET IDENTITY_INSERT [dbo].[PaymentInformation] ON 

GO
INSERT [dbo].[PaymentInformation] ([Id], [UserId], [AccountName], [Address], [Address1], [City], [State], [Zip], [CardNumber], [CVS], [Month], [Year], [LastFourDigitCard], [IsCheckingAccount], [RoutingNo], [AccountNo], [CheckNo], [IsRecurring], [IsAgree]) VALUES (1, N'1', N'Somers Butcher', N'809 N Bethlehem Pike', N'', N'Ambler', N'PA', N'19002', N'', N'', N'', N'', N'2132', 1, N'031918873', N'152132', N'', 1, 1)
GO
INSERT [dbo].[PaymentInformation] ([Id], [UserId], [AccountName], [Address], [Address1], [City], [State], [Zip], [CardNumber], [CVS], [Month], [Year], [LastFourDigitCard], [IsCheckingAccount], [RoutingNo], [AccountNo], [CheckNo], [IsRecurring], [IsAgree]) VALUES (3, N'1', N'Joe Clean', N'100 North Street.', N'', N'NY', N'PA', N'19002', N'5123 4567 8901 2346', N'123', N'12', N'2021', N'2346', 0, N'', N'', N'', 1, 1)
GO
INSERT [dbo].[PaymentInformation] ([Id], [UserId], [AccountName], [Address], [Address1], [City], [State], [Zip], [CardNumber], [CVS], [Month], [Year], [LastFourDigitCard], [IsCheckingAccount], [RoutingNo], [AccountNo], [CheckNo], [IsRecurring], [IsAgree]) VALUES (5, N'2', N'Joe Clean', N'150 Horse Rd', N'', N'Flourtown', N'PA', N'19002', N'', N'', N'', N'', N'5678', 1, N'125008547', N'12345678', N'', 1, 1)
GO
SET IDENTITY_INSERT [dbo].[PaymentInformation] OFF
GO
SET IDENTITY_INSERT [dbo].[ReferralAccount] ON 

GO
INSERT [dbo].[ReferralAccount] ([Id], [GiverPhone], [GetterPhone], [CreatedDate], [StartDate], [EndDate], [YTD_Commission], [MTD_Commission], [YTD_CommissionOwed], [MTD_CommissionOwed], [YTD_CommissionPaid], [MTD_CommissionPaid], [LastTransactionDate]) VALUES (1, N'8801817708661', N'8801817708660', CAST(0x0000AB5F0104E3A8 AS DateTime), CAST(0x0000AB7A00F0AF87 AS DateTime), CAST(0x0000ACE700F0B00F AS DateTime), N'0.594', N'0.05', N'0.1500', N'0.05', N'0', N'0', CAST(0x0000ABE301176DB3 AS DateTime))
GO
INSERT [dbo].[ReferralAccount] ([Id], [GiverPhone], [GetterPhone], [CreatedDate], [StartDate], [EndDate], [YTD_Commission], [MTD_Commission], [YTD_CommissionOwed], [MTD_CommissionOwed], [YTD_CommissionPaid], [MTD_CommissionPaid], [LastTransactionDate]) VALUES (2, N'8801817708662', N'8801817708660', CAST(0x0000ABD501542567 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[ReferralAccount] ([Id], [GiverPhone], [GetterPhone], [CreatedDate], [StartDate], [EndDate], [YTD_Commission], [MTD_Commission], [YTD_CommissionOwed], [MTD_CommissionOwed], [YTD_CommissionPaid], [MTD_CommissionPaid], [LastTransactionDate]) VALUES (3, N'8801819330330', N'12156691499', CAST(0x0000AC280115D90C AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[ReferralAccount] OFF
GO
SET IDENTITY_INSERT [dbo].[ReferralTransaction] ON 

GO
INSERT [dbo].[ReferralTransaction] ([Id], [GiverPhone], [GetterPhone], [TransactionDate], [PayorAmount], [Description], [Month], [Year], [Remarks], [CreatedDate], [CommissionMonthDate], [IsPaid], [CommissionFor], [ZipCode]) VALUES (1, N'8801817708661', N'8801816027706', CAST(0x0000ABCC018B80D4 AS DateTime), 0.1000, N'dealer commission added for March 2020', N'March', N'2020', N'dealer commission added', CAST(0x0000ABE30115987B AS DateTime), CAST(0x0000AB7100000000 AS DateTime), 0, N'Dealer', N'19034')
GO
INSERT [dbo].[ReferralTransaction] ([Id], [GiverPhone], [GetterPhone], [TransactionDate], [PayorAmount], [Description], [Month], [Year], [Remarks], [CreatedDate], [CommissionMonthDate], [IsPaid], [CommissionFor], [ZipCode]) VALUES (2, N'8801817708661', N'8801816027706', CAST(0x0000ABCC018B80D4 AS DateTime), 0.1000, N'dealer commission added for April 2020', N'April', N'2020', N'dealer commission added', CAST(0x0000ABE301159884 AS DateTime), CAST(0x0000AB9000000000 AS DateTime), 0, N'Dealer', N'19034')
GO
INSERT [dbo].[ReferralTransaction] ([Id], [GiverPhone], [GetterPhone], [TransactionDate], [PayorAmount], [Description], [Month], [Year], [Remarks], [CreatedDate], [CommissionMonthDate], [IsPaid], [CommissionFor], [ZipCode]) VALUES (3, N'8801817708661', N'8801816027706', CAST(0x0000ABCC018B80D4 AS DateTime), 0.1000, N'dealer commission added for May 2020', N'May', N'2020', N'dealer commission added', CAST(0x0000ABE301159884 AS DateTime), CAST(0x0000ABAE00000000 AS DateTime), 0, N'Dealer', N'19034')
GO
INSERT [dbo].[ReferralTransaction] ([Id], [GiverPhone], [GetterPhone], [TransactionDate], [PayorAmount], [Description], [Month], [Year], [Remarks], [CreatedDate], [CommissionMonthDate], [IsPaid], [CommissionFor], [ZipCode]) VALUES (4, N'8801817708661', N'8801817708660', CAST(0x0000ABCC018B80D4 AS DateTime), 0.0100, N'commission added for March 2020', N'March', N'2020', N'commission added', CAST(0x0000ABE301176DB3 AS DateTime), CAST(0x0000AB7100000000 AS DateTime), 1, N'User', NULL)
GO
INSERT [dbo].[ReferralTransaction] ([Id], [GiverPhone], [GetterPhone], [TransactionDate], [PayorAmount], [Description], [Month], [Year], [Remarks], [CreatedDate], [CommissionMonthDate], [IsPaid], [CommissionFor], [ZipCode]) VALUES (5, N'8801817708661', N'8801817708660', CAST(0x0000ABCC018B80D4 AS DateTime), 0.0500, N'commission added for April 2020', N'April', N'2020', N'commission added', CAST(0x0000ABE301176DB3 AS DateTime), CAST(0x0000AB9000000000 AS DateTime), 0, N'User', NULL)
GO
INSERT [dbo].[ReferralTransaction] ([Id], [GiverPhone], [GetterPhone], [TransactionDate], [PayorAmount], [Description], [Month], [Year], [Remarks], [CreatedDate], [CommissionMonthDate], [IsPaid], [CommissionFor], [ZipCode]) VALUES (6, N'8801817708661', N'8801817708660', CAST(0x0000ABCC018B80D4 AS DateTime), 0.0500, N'commission added for May 2020', N'May', N'2020', N'commission added', CAST(0x0000ABE301176DB3 AS DateTime), CAST(0x0000ABAE00000000 AS DateTime), 0, N'User', NULL)
GO
INSERT [dbo].[ReferralTransaction] ([Id], [GiverPhone], [GetterPhone], [TransactionDate], [PayorAmount], [Description], [Month], [Year], [Remarks], [CreatedDate], [CommissionMonthDate], [IsPaid], [CommissionFor], [ZipCode]) VALUES (7, N'8801817708661', N'8801817708660', CAST(0x0000ABCC018B80D4 AS DateTime), 0.0400, N'commission added for March 2020', N'March', N'2020', N'commission added', CAST(0x0000ABE301176DB3 AS DateTime), CAST(0x0000AB7100000000 AS DateTime), 0, N'User', NULL)
GO
SET IDENTITY_INSERT [dbo].[ReferralTransaction] OFF
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'AK', N'ALASKA', CAST(0.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'AL', N'ALABAMA', CAST(4.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'AR', N'ARKANSAS', CAST(6.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'AZ', N'ARIZONA', CAST(5.600 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'CA', N'CALIFORNIA', CAST(7.250 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'CO', N'COLORADO', CAST(2.900 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'CT', N'CONNECTICUT', CAST(6.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'DC', N'DISTRICT OF COLUMBIA', CAST(5.750 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'DE', N'DELAWARE', CAST(0.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'FL', N'FLORIDA', CAST(6.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'GA', N'GEORGIA', CAST(4.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'HI', N'HAWAII', CAST(4.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'IA', N'IOWA', CAST(5.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'ID', N'IDAHO', CAST(6.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'IL', N'ILLINOIS', CAST(6.250 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'IN', N'INDIANA', CAST(6.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'KS', N'KANSAS', CAST(5.300 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'KY', N'KENTUCKY', CAST(6.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'LA', N'LOUISIANA', CAST(4.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'MA', N'MASSACHUSETTS', CAST(5.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'MD', N'MARYLAND', CAST(5.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'ME', N'MAINE', CAST(5.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'MI', N'MICHIGAN', CAST(6.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'MN', N'MINNESOTA', CAST(6.500 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'MO', N'MISSOURI', CAST(4.225 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'MS', N'MISSISSIPPI', CAST(7.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'MT', N'MONTANA', CAST(0.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'NC', N'NORTH CAROLINA', CAST(4.250 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'ND', N'NORTH DAKOTA', CAST(5.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'NE', N'NEBRASKA', CAST(5.500 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'NH', N'NEW HAMPSHIRE', CAST(0.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'NJ', N'NEW JERSEY', CAST(6.875 AS Numeric(6, 3)), N'Y', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'NM', N'NEW MEXICO', CAST(5.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'NV', N'NEVADA', CAST(6.500 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'NY', N'NEW YORK', CAST(4.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'OH', N'OHIO', CAST(5.500 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'OK', N'OKLAHOMA', CAST(4.500 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'OR', N'OREGON', CAST(0.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'PA', N'PENNSYLVANIA', CAST(6.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'RI', N'RHODE ISLAND', CAST(7.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'SC', N'SOUTH CAROLINA', CAST(5.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'SD', N'SOUTH DAKOTA', CAST(4.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'TN', N'TENNESSEE', CAST(7.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'TX', N'TEXAS', CAST(6.250 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'UT', N'UTAH', CAST(4.750 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'VA', N'VIRGINIA', CAST(5.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'VT', N'VERMONT', CAST(6.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'WA', N'WASHINGTON', CAST(6.500 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'WI', N'WISCONSIN', CAST(5.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'WV', N'WEST VIRGINIA', CAST(6.000 AS Numeric(6, 3)), N'N', NULL)
GO
INSERT [dbo].[States] ([STATE], [STATENAME], [SalesTaxRate], [FreightTaxable], [ShippingSurcharge]) VALUES (N'WY', N'WYOMING', CAST(4.000 AS Numeric(6, 3)), N'N', NULL)
GO
SET IDENTITY_INSERT [dbo].[SystemInformation] ON 

GO
INSERT [dbo].[SystemInformation] ([Id], [UserId], [Website], [EmailServer1], [EmailUser1], [EmailPassword1], [EmailServer2], [EmailUser2], [EmailPassword2], [EmailServer3], [EmailUser3], [EmailPassword3], [EmailServer4], [EmailUser4], [EmailPassword4], [SecurityLink], [SecurityKey], [SecurityUser], [SecurityPassword], [CreditCardLink], [CreditCardKey], [CreditCardUser], [CreditCardPassword], [DocumentLink], [ApplicationFee], [FeeType], [FeePercentage], [FeeFlatAmount], [IncludeProcessFees], [TanentPayFees], [CreditCardProcessFees], [OneTimePay], [RecurringPay], [IsGlobalSystem], [FeeTypeCheck], [FeePercentageCheck], [FeeFlatAmountCheck]) VALUES (1, N'1', N'etag365.net', N'etag365.com', N'aftab@etag365.com', N'123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'etag365.net', N'123', N'aftab@etag365.com', N'123', N'etag365.net', N'123', N'aftab@etag365.com', N'123', NULL, NULL, 1, CAST(4.5000 AS Decimal(18, 4)), CAST(0.0000 AS Decimal(18, 4)), 1, 0, CAST(0.0000 AS Decimal(18, 4)), 0, 1, 1, 1, CAST(0.2500 AS Decimal(18, 4)), CAST(0.0000 AS Decimal(18, 4)))
GO
SET IDENTITY_INSERT [dbo].[SystemInformation] OFF
GO
SET IDENTITY_INSERT [dbo].[UserLog_Data] ON 

GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (3413, N'lglfvxj2xmelunbsqclcuzmp', 2, CAST(0x0000AC080014D64E AS DateTime), 1, CAST(0x0000AC080014D64E AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (3414, N'2zffuzbzsm1ypswv4eubnoxu', 2, CAST(0x0000AC08001ABA7A AS DateTime), 1, CAST(0x0000AC08001ABA7A AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4393, N'xyydsvawzcvmg1aqrpr2r2b1', 2, CAST(0x0000AC08016EDDEC AS DateTime), 1, CAST(0x0000AC08016EDDEC AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4394, N'xyydsvawzcvmg1aqrpr2r2b1', 2, CAST(0x0000AC080171CB2A AS DateTime), 1, CAST(0x0000AC080171CB2A AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4395, N'xyydsvawzcvmg1aqrpr2r2b1', 2, CAST(0x0000AC08017234D0 AS DateTime), 1, CAST(0x0000AC08017234D0 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4396, N'wq5prh01idxqowugtd3vihut', 2, CAST(0x0000AC0C000DC32C AS DateTime), 1, CAST(0x0000AC0C000DC32C AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4397, N'wq5prh01idxqowugtd3vihut', 2, CAST(0x0000AC0C0017AC95 AS DateTime), 1, CAST(0x0000AC0C0017AC95 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4398, N'wq5prh01idxqowugtd3vihut', 2, CAST(0x0000AC0C0019FA27 AS DateTime), 1, CAST(0x0000AC0C0019FA27 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4400, N'zroltcrup1rzqtnjvnxb4nwz', 2, CAST(0x0000AC0C0170A02E AS DateTime), 1, CAST(0x0000AC0C0170A02E AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4401, N'jyidqlya54ttzgvh3djb2b3e', 2, CAST(0x0000AC0C017403E6 AS DateTime), 1, CAST(0x0000AC0C017403E6 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4403, N'bd41qgo2bp54phzpnfdri0p3', 13, CAST(0x0000AC0E001DF8E4 AS DateTime), 1, CAST(0x0000AC0E001DF8E4 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4415, N'3x0td4tjtyvmw0ekmmv3wpmz', 17, CAST(0x0000AC1F0126A2F6 AS DateTime), 1, CAST(0x0000AC1F0126A2F6 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4421, N'3a3pro40nn0mjfn1oqcx3cqk', 21, CAST(0x0000AC210006829F AS DateTime), 1, CAST(0x0000AC210006829F AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4422, N'3a3pro40nn0mjfn1oqcx3cqk', 21, CAST(0x0000AC21000A1935 AS DateTime), 1, CAST(0x0000AC21000A1935 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4444, N'lompyfgwzrdleeuxtzx1twm4', 2, CAST(0x0000AC2800F18C36 AS DateTime), 1, CAST(0x0000AC2800F18C36 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4446, N'lompyfgwzrdleeuxtzx1twm4', 2, CAST(0x0000AC28010F8C8B AS DateTime), 1, CAST(0x0000AC28010F8C8B AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (4453, N'cne02n43uxb4xfiglkma1h3a', 28, CAST(0x0000AC6A012C6B79 AS DateTime), 1, CAST(0x0000AC6A012C6B79 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (9479, N'2vcpme4m5pjo2nd0idaaatqj', 1, CAST(0x0000ACD100102185 AS DateTime), 1, CAST(0x0000ACD100102185 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (9480, N'2vcpme4m5pjo2nd0idaaatqj', 1, CAST(0x0000ACD100122598 AS DateTime), 1, CAST(0x0000ACD100122598 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (9481, N'ka5zdnyx3fylzd4nc3zptcmt', 1, CAST(0x0000ACD300E74FEA AS DateTime), 1, CAST(0x0000ACD300E74FEA AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (9482, N'ka5zdnyx3fylzd4nc3zptcmt', 1, CAST(0x0000ACD300F62154 AS DateTime), 1, CAST(0x0000ACD300F62154 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (9483, N'ka5zdnyx3fylzd4nc3zptcmt', 1, CAST(0x0000ACD300FCC0A8 AS DateTime), 1, CAST(0x0000ACD300FCC0A8 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (9484, N'ka5zdnyx3fylzd4nc3zptcmt', 1, CAST(0x0000ACD301003276 AS DateTime), 1, CAST(0x0000ACD301003276 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (9485, N'ka5zdnyx3fylzd4nc3zptcmt', 1, CAST(0x0000ACD30139A9C9 AS DateTime), 1, CAST(0x0000ACD30139A9C9 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (9486, N'p1ob44agegx1jrcge2blmkds', 1, CAST(0x0000ACDF000A7325 AS DateTime), 1, CAST(0x0000ACDF000A7325 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (9487, N'qtefu2ajmp0aq5cw2ai11tvo', 1, CAST(0x0000ACDF0162647E AS DateTime), 1, CAST(0x0000ACDF0162647E AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10478, N'f4dpkqy50cl5ibctqmaymyij', 1, CAST(0x0000ACE5001537C7 AS DateTime), 1, CAST(0x0000ACE5001537C7 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10479, N'540jjr4rg3rzbq0xokzfkh3y', 1, CAST(0x0000ACE5001A6805 AS DateTime), 1, CAST(0x0000ACE5001A6805 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10480, N'jlztrwdzgmj1g5xtnpjjyczw', 1, CAST(0x0000ACE5001D48AF AS DateTime), 1, CAST(0x0000ACE5001D48AF AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10481, N'4ib14nsid5kxadq1frjhqqf3', 1, CAST(0x0000ACE500C30DC2 AS DateTime), 1, CAST(0x0000ACE500C30DC2 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10482, N'wz2uohqeb24gyqj5kf3xc1gc', 1, CAST(0x0000ACF8001C1469 AS DateTime), 1, CAST(0x0000ACF8001C1469 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10483, N'ggdq232ctqjjklybw12yayqh', 1, CAST(0x0000ACFA016A5551 AS DateTime), 1, CAST(0x0000ACFA016A5551 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10484, N'ggdq232ctqjjklybw12yayqh', 1, CAST(0x0000ACFB000A70D7 AS DateTime), 1, CAST(0x0000ACFB000A70D7 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10485, N'ggdq232ctqjjklybw12yayqh', 1, CAST(0x0000ACFB0016CBB0 AS DateTime), 1, CAST(0x0000ACFB0016CBB0 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10486, N'ggdq232ctqjjklybw12yayqh', 1, CAST(0x0000ACFB00210523 AS DateTime), 1, CAST(0x0000ACFB00210523 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10487, N'ggdq232ctqjjklybw12yayqh', 1, CAST(0x0000ACFB0026C17E AS DateTime), 1, CAST(0x0000ACFB0026C17E AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10488, N'akush05wcqsqel3rnfasw2ch', 1, CAST(0x0000ACFB002C446B AS DateTime), 1, CAST(0x0000ACFB002C446B AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10489, N'g2040qoarj1ec1d2qtmkci5l', 1, CAST(0x0000ACFB0117964C AS DateTime), 1, CAST(0x0000ACFB0117964C AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10490, N'dmb320fy3211vrwziuieqxyg', 1, CAST(0x0000ACFE00C5DD2B AS DateTime), 1, CAST(0x0000ACFE00C5DD2B AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10491, N'qiywqkotpcuvhsxuimhmztnd', 1, CAST(0x0000ACFE00E8A46D AS DateTime), 1, CAST(0x0000ACFE00E8A46D AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10492, N'y4u3shdgynoj1lvxy1rtzxxq', 1, CAST(0x0000ACFE00F75784 AS DateTime), 1, CAST(0x0000ACFE00F75784 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10493, N'3152n322b1cn20beln13u0pz', 1029, CAST(0x0000AD23000FCB1E AS DateTime), 1, CAST(0x0000AD23000FCB1E AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10494, N'5rmheia5kikpp3ham3tj5jvz', 1, CAST(0x0000AD23010B1848 AS DateTime), 1, CAST(0x0000AD23010B1848 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10495, N'3jx52yo4gcuz3deqvcgbrnuh', 1, CAST(0x0000AD8C00136A3D AS DateTime), 1, CAST(0x0000AD8C00136A3D AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10496, N'3jx52yo4gcuz3deqvcgbrnuh', 1, CAST(0x0000AD8C0013A643 AS DateTime), 1, CAST(0x0000AD8C0013A643 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10497, N'3jx52yo4gcuz3deqvcgbrnuh', 1, CAST(0x0000AD8C0013D6F7 AS DateTime), 1, CAST(0x0000AD8C0013D6F7 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10498, N'3jx52yo4gcuz3deqvcgbrnuh', 1, CAST(0x0000AD8C00149BF4 AS DateTime), 1, CAST(0x0000AD8C00149BF4 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10499, N'1frcfvkhs2egfrsjoiuur4zr', 1, CAST(0x0000AE1B0019119B AS DateTime), 1, CAST(0x0000AE1B0019119B AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10500, N'hjw04ayogkggj450wcflujjw', 1, CAST(0x0000AE5100105922 AS DateTime), 1, CAST(0x0000AE5100105922 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10501, N'hjw04ayogkggj450wcflujjw', 1, CAST(0x0000AE510010C9C4 AS DateTime), 1, CAST(0x0000AE510010C9C4 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10502, N'hjw04ayogkggj450wcflujjw', 1, CAST(0x0000AE510011A5FA AS DateTime), 1, CAST(0x0000AE510011A5FA AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10503, N'vq32fpwl03mu3bmowmvlmmeh', 1, CAST(0x0000AE5101857220 AS DateTime), 1, CAST(0x0000AE5101857220 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10504, N'0hdo1hcmmhgeoqfqabgtxjh1', 1, CAST(0x0000AE52016AF91C AS DateTime), 1, CAST(0x0000AE52016AF91C AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10505, N'vmzunqx3grl3b4jsqb31ixil', 1, CAST(0x0000AE6D0187BCE6 AS DateTime), 1, CAST(0x0000AE6D0187BCE6 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10506, N'zmgvrfqbzji31jpwrkkl1who', 1, CAST(0x0000AE6F001593E2 AS DateTime), 1, CAST(0x0000AE6F001593E2 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10507, N'fsripwefxfgk2dxoun5kxnvr', 1, CAST(0x0000AE6F01759D08 AS DateTime), 1, CAST(0x0000AE6F01759D08 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10508, N'atvbucuobv04bocxxqqpsd13', 1, CAST(0x0000AE6F0176E57B AS DateTime), 1, CAST(0x0000AE6F0176E57B AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10509, N'rymjh5jwsrob32ttuahcjb25', 1, CAST(0x0000AE6F01788FA6 AS DateTime), 1, CAST(0x0000AE6F01788FA6 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10510, N'kux3txylqqfyfugh0wt440hc', 1, CAST(0x0000AE6F017B08E4 AS DateTime), 1, CAST(0x0000AE6F017B08E4 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10511, N'shlefyy5dzy2no0g3g50bc0d', 1, CAST(0x0000AE6F017C61DD AS DateTime), 1, CAST(0x0000AE6F017C61DD AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10512, N'giuqukow2s3shcogjxp4zgy5', 1, CAST(0x0000AE6F017D1BC3 AS DateTime), 1, CAST(0x0000AE6F017D1BC3 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10513, N'4t4xyc413hr54aqz4u3vzx4u', 1, CAST(0x0000AE6F017DDAFC AS DateTime), 1, CAST(0x0000AE6F017DDAFC AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10514, N'5crqoaile0uzexftkcypxsfk', 1, CAST(0x0000AE71000581A2 AS DateTime), 1, CAST(0x0000AE71000581A2 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10515, N'bzpfiml1stfqh4kujmtsuyiw', 1, CAST(0x0000AEEA0008E27F AS DateTime), 1, CAST(0x0000AEEA0008E27F AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10516, N'lf14e1qmm4org0b4y0zjifav', 1, CAST(0x0000AEF800043F77 AS DateTime), 1, CAST(0x0000AEF800043F77 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10517, N'lf14e1qmm4org0b4y0zjifav', 1, CAST(0x0000AEF800050541 AS DateTime), 1, CAST(0x0000AEF800050541 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10518, N'w4vgopy4ufunhhmh0lfe2w1k', 1, CAST(0x0000AF8300F95EA8 AS DateTime), 1, CAST(0x0000AF8300F95EA8 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10519, N'w4vgopy4ufunhhmh0lfe2w1k', 1, CAST(0x0000AF830183DDE1 AS DateTime), 1, CAST(0x0000AF830183DDE1 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10520, N'bf0dx3kyahvfcoqe4jrt4tij', 1, CAST(0x0000AF84014571F2 AS DateTime), 1, CAST(0x0000AF84014571F2 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10521, N'bf0dx3kyahvfcoqe4jrt4tij', 1, CAST(0x0000AF8401644D33 AS DateTime), 1, CAST(0x0000AF8401644D33 AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10522, N'bf0dx3kyahvfcoqe4jrt4tij', 1, CAST(0x0000AF84016CDC9D AS DateTime), 1, CAST(0x0000AF84016CDC9D AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10523, N'bf0dx3kyahvfcoqe4jrt4tij', 1, CAST(0x0000AF840170068C AS DateTime), 1, CAST(0x0000AF840170068C AS DateTime))
GO
INSERT [dbo].[UserLog_Data] ([LogId], [SessionId], [UserId], [LoginDate], [Status], [LastUpdate]) VALUES (10524, N'bf0dx3kyahvfcoqe4jrt4tij', 1, CAST(0x0000AF8500073C29 AS DateTime), 1, CAST(0x0000AF8500073C29 AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[UserLog_Data] OFF
GO
SET IDENTITY_INSERT [dbo].[UserPricing] ON 

GO
INSERT [dbo].[UserPricing] ([Id], [UserPlans], [MonthlyCosts], [Billed], [ContactsImportsMonthly], [ContactExportsYearly], [StoredContacts], [Contacts_500], [Contacts_10000], [ReferralCommissions], [eTag365NFCChip]) VALUES (1, N'Basic', CAST(0.99 AS Decimal(18, 2)), N'Yearly', N'10', N'250', N'500', N'1.00', N'N/A', 1, 1)
GO
INSERT [dbo].[UserPricing] ([Id], [UserPlans], [MonthlyCosts], [Billed], [ContactsImportsMonthly], [ContactExportsYearly], [StoredContacts], [Contacts_500], [Contacts_10000], [ReferralCommissions], [eTag365NFCChip]) VALUES (2, N'Silver', CAST(4.99 AS Decimal(18, 2)), N'Monthly', N'50', N'500', N'10000', N'N/A', N'3.99', 1, 1)
GO
INSERT [dbo].[UserPricing] ([Id], [UserPlans], [MonthlyCosts], [Billed], [ContactsImportsMonthly], [ContactExportsYearly], [StoredContacts], [Contacts_500], [Contacts_10000], [ReferralCommissions], [eTag365NFCChip]) VALUES (3, N'Gold', CAST(9.99 AS Decimal(18, 2)), N'Monthly', N'unlimited', N'unlimited', N'unlimited', N'N/A', N'N/A', 1, 1)
GO
SET IDENTITY_INSERT [dbo].[UserPricing] OFF
GO
SET IDENTITY_INSERT [dbo].[UserProfile] ON 

GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1, N'8801817708660', N'U00000000001', N'MTIz', N'aftab@2rsolution.com', N'8801817708660', N'983353', N'GEOFFREY', NULL, N'TSUMA', N'U00000000001_P_IMG_20191121_232745.jpg', N'ABC', N'U00000000001_C_1.jpg', N'8801817708660', N'111', N'8801817708660', 1, 0, 1, 1, 1, N'100', N'100', N'Newark', N'US', N'ny', N'new york', N'19034', N'none', NULL, NULL, N'2', 1, 0, 1, 1, 1, 1, 1, NULL, NULL, N'250', N'11', N'1', N'10', N'8801817708660', CAST(0x0000AB49012F1FF3 AS DateTime), N'8801817708660', CAST(0x0000ABB700F0E265 AS DateTime), NULL, N'Aftab', NULL, N'Basic', CAST(0x0000AD24000C6BF5 AS DateTime), NULL, 0, CAST(0x0000AE1B001BA27D AS DateTime), CAST(0x0000AD23010BC499 AS DateTime), N'500', 1, N'880', NULL, NULL, 0, CAST(0x0000AD2000CC5AD6 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (2, N'8801817708661', N'U00000000002', N'MTIz', N'a@a.com', N'8801817708661', NULL, N'John Doe', NULL, N'Doe', N'U00000000002_P_logo.png', N'Test', NULL, N'8801817708661', N'', N'8801817708661', 1, 0, 1, 0, 0, N'7100 E Valley Green Road', N'', N'PENNSYLVANIA', N'BD', N'PA', N'Fort Washington', N'19034', N'No Typing Information - Right Every Time -Saves hundreds hours of input per year. Reduce Your Printing Cost. Cancel anytime. First 30 days money back.Easy export to favor CRM', NULL, NULL, N'2', 0, 0, 1, 1, 1, 0, NULL, N'www.etag365.net', N'Category1', N'unlimited', N'2', NULL, N'unlimited', N'8801817708661', CAST(0x0000AB5F0104E243 AS DateTime), N'8801817708660', CAST(0x0000AC2A00256552 AS DateTime), N'8801817708661', N'', N'Main', N'Gold', CAST(0x0000AD2D012890AC AS DateTime), CAST(0x0000AD2D012890AC AS DateTime), 0, NULL, CAST(0x0000ABF5000B2073 AS DateTime), N'unlimited', 1, N'880', N'', N'', 0, CAST(0x0000ACFE00B41B67 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (3, N'8801816027706', N'100001', N'MTIz', N'dealer1@etag365.com', N'8801816027706', NULL, N'Aminul', NULL, N'Islam', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, N'US', N'NY', N'new york', NULL, NULL, NULL, NULL, N'3', 0, 0, 1, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'8801816027706', CAST(0x0000AB5F0104E243 AS DateTime), N'8801816027706', CAST(0x0000AB8B000FA93B AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'880', NULL, NULL, 1, NULL)
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (6, N'8801816027708', N'100002', N'MTIz', N'dealer2@etag365.com', N'8801816027708', NULL, N'Test', NULL, N'Dealer2', NULL, NULL, NULL, N'8801816027707', NULL, NULL, 1, 0, 1, NULL, NULL, N'test', N'', NULL, N'US', N'AL', N'test', N'19001', NULL, NULL, NULL, N'3', 0, 0, 1, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AB8B0035C2D8 AS DateTime), N'8801816027707', CAST(0x0000ABCE002BE163 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'880', NULL, NULL, 1, NULL)
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (21, N'8801817708663', N'U00000000003', N'MTIz', NULL, N'8801817708663', N'242847', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'BD', NULL, NULL, NULL, NULL, N'', N'', N'2', 0, 0, 1, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'8801817708663', CAST(0x0000AC2100062029 AS DateTime), N'8801817708663', CAST(0x0000AC2100065E7E AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'880', NULL, NULL, 1, NULL)
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (22, N'8801817708662', N'U00000000004', N'MTIz', N'aftab@2rsolution.com', N'8801817708662', N'410533', N'John', NULL, N'Doe', NULL, N'ADI', NULL, N'', N'', N'', 0, 0, 1, 0, 0, N'1222', N'', N'INDIANA', N'BD', N'IN', N'test', N'15000', N'', N'', N'', N'2', 0, 0, 1, 1, 1, 0, NULL, N'', N'Category1', NULL, NULL, NULL, NULL, N'8801817708662', CAST(0x0000AC2800E7BC65 AS DateTime), N'8801817708660', CAST(0x0000AC9200C181FE AS DateTime), N'', N'', N'Other', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'880', N'', N'', 1, NULL)
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (24, N'12156691499', N'U00000000005', N'MTIxNTY2OTE0OTk=', N'sbutcher@etag365.com', N'12156691499', N'9451', N'Sandy', NULL, N'Butcher', NULL, N' eTag365', NULL, N'12156691499', N'1207', N'2152331825', 1, 1, 0, 0, 0, N'809 N Bethlehem Pike ', N' Spring House Square Bldg B Suite BR ', NULL, N'US', N'PA', N'Ambler ', N'19002', N' No Typing Information - Right Every Time -Saves hundreds hours of input per year. Reduce Your Printing Cost. Cancel anytime. First 30 days money back.Easy export to favor CRM ', NULL, NULL, N'2', 0, 0, 1, 1, 1, 0, NULL, N'test.com', N'ADI', NULL, NULL, NULL, NULL, N'12156691499', CAST(0x0000AC280114BA9A AS DateTime), NULL, NULL, N'2156691499', N'President ', N'Work', NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, N'1', NULL, NULL, 1, CAST(0x0000ACFE00EB5C71 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (25, N'8801819330330', N'U00000000006', N'ODgwMTgxOTMzMDMzMA==', NULL, N'8801819330330', NULL, N'Shakil', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 0, 0, NULL, NULL, NULL, N'US', NULL, NULL, NULL, NULL, NULL, NULL, N'2', 0, 0, 1, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'8801819330330', CAST(0x0000AC280115D8E8 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, N'880', NULL, NULL, 1, NULL)
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (26, N'12156691498', N'U00000000007', N'MTIxNTY2OTE0OTg=', N' a@etag365.com ', N'12156691498', NULL, N'Sandy', NULL, N'Butcher', NULL, N' eTag365', NULL, N'2156691499', N'1207', N'2152331825', 0, 1, 0, 0, 0, N'809 N Bethlehem Pike ', N' Spring House Square Bldg B Suite BR ', NULL, N'US', N'PA', N'Ambler ', N'19002', N' No Typing Information - Right Every Time -Saves hundreds hours of input per year. Reduce Your Printing Cost. Cancel anytime. First 30 days money back.Easy export to favor CRM ', NULL, NULL, N'2', 0, 0, 1, 1, 1, 0, NULL, N'test.com', N'ADI', NULL, NULL, NULL, NULL, N'12156691498', CAST(0x0000AC28011A034A AS DateTime), NULL, NULL, N'2156691499', N'President ', N'Work', NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, N'1', NULL, NULL, 1, NULL)
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1027, N'14046451335', N'U00000000008', N'MTQwNDY0NTEzMzU=', N'abc@adi.com', N'14046451335', NULL, N'GEOFFREY', N'', N'TSUMA', NULL, N'ABC', NULL, NULL, NULL, NULL, 0, 1, 0, 0, 0, NULL, NULL, NULL, N'US', NULL, NULL, NULL, NULL, NULL, NULL, N'2', 0, 0, 1, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'14046451335', CAST(0x0000AD2000CC50C1 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, N'1', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1028, N'12123335679', N'U00000000009', N'MTIxMjMzMzU2Nzk=', N'abc@a.com', N'12123335679', NULL, N'John', N'', N'Doe', N'', N'', NULL, N'NULL', N'NULL', N'NULL', 0, 1, 0, 0, 0, N'100 North Street', N'', N'NY', N'US', N'NY', N'New York', N'19034', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, NULL, N'Category1', NULL, NULL, NULL, NULL, N'1', CAST(0x0000AD22018AA94B AS DateTime), NULL, NULL, N'NULL', N'John Doe', N'Phone', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AD22018AA95C AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1029, N'12123335678', N'U00000000010', N'MTIzNA==', N'aftab@2rsolution.com', N'12123335678', N'9451', N'John', N'', N'Doe', N'', N'', NULL, N'NULL', N'NULL', N'NULL', 1, 0, 0, 0, 0, N'100 North Street', N'', N'NY', N'US', N'NY', N'New York', N'19034', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'NA', N'Category1', NULL, NULL, NULL, NULL, N'1', CAST(0x0000AD23000B6A47 AS DateTime), N'12123335678', CAST(0x0000AD23000FB6BB AS DateTime), N'NULL', N'John Doe', N'Phone', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, N'1', NULL, NULL, 1, CAST(0x0000AD23000BA332 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1030, N'8801817708665', N'U00000000011', N'ODgwMTgxNzcwODY2NQ==', N'abc@a.com', N'8801817708665', NULL, N'John', N'', N'Clean', N'', N'', NULL, N'', N'', N'', 0, 1, 0, 0, 0, N'', N'', N'', N'US', N'', N'', N'', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'', N'', NULL, NULL, NULL, NULL, N'1', CAST(0x0000AD23010A41C9 AS DateTime), NULL, NULL, N'', N'', N'', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AD23010A41D0 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1032, N'12123335670', N'U00000000013', N'MTIxMjMzMzU2NzA=', N'a@a.com', N'12123335670', NULL, N'John', N'', N'Doe', N'', N'ABC', NULL, N'NULL', N'NULL', N'NULL', 0, 1, 0, 0, 0, N'100 North Street', N'', N'NY', N'US', N'NY', N'New York', N'19034', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'abc.com', N'Category1', NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AD23011655F4 AS DateTime), NULL, NULL, N'NULL', N'John Doe', N'Phone', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AD23011655F4 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1033, N'8801817708667', N'U00000000014', N'ODgwMTgxNzcwODY2Nw==', N'clean@etag.com', N'8801817708667', NULL, N'Joe', N'', N'Clean', N'', N'', NULL, N'', N'', N'', 0, 1, 0, 0, 0, N'', N'', N'', N'US', N'', N'', N'', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'', N'', NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AD23011782FD AS DateTime), NULL, NULL, N'', N'', N'', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AD23011782FD AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1034, N'12676201170', N'U00000000015', N'MTI2NzYyMDExNzA=', N'a@a.com', N'12676201170', NULL, N'Jamal', N'', N'Heacock', N'', N'Aeroflot Airlines, a.s', NULL, N'267-620-1171', N'1207', N'267-620-1175', 0, 1, 0, 0, 0, N'100 North Street.', N'', N'', N'US', N'PA', N'New York City', N'19134', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'www.gastropa.com', N'', NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AD230117EB42 AS DateTime), NULL, NULL, N'8801817708660', N'IT Manager', N'', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AD230117EB42 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1035, N'18682346130', N'U00000000016', N'MTg2ODIzNDYxMzA=', N'', N'18682346130', NULL, N'Shenzhen Xinyetong Technology', N'', N'', N'', N'Shenzhen Xinyetong Technology Co.,Ltd.', NULL, N'755-26979016', N'', N'755-86593863', 0, 1, 0, 0, 0, N'16th Floor, Jingyuan Masion', N'', N'', N'US', N'Shenzhen', N'Longgang District', N'518112', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'', N'', NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AD230118CC6B AS DateTime), NULL, NULL, N'', N'', N'', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AD230118CC6B AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1036, N'12676201171', N'U00000000017', N'MTI2NzYyMDExNzE=', N'jamal@gastropa.com', N'12676201171', NULL, N'Jamal', N'', N'Heacock', N'', N'Shenzhen Xinyetong Technology Co.,Ltd', NULL, N'267-620-1171', N'', N'267-620-1175', 0, 1, 0, 0, 0, N'2000 AVENUE OF THE STARS, LOS ANGELES', N'', N'', N'US', N'CA', N'LOS ANGELES', N'90067', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'www.etag365.com', N'', NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AD230142F7F0 AS DateTime), NULL, NULL, N'267-620-1176', N'IT Manager', N'', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AD230142F7F8 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1037, N'12676201177', N'U00000000018', N'MTI2NzYyMDExNzc=', N'jamal@gastropa.com', N'12676201177', NULL, N'Jamal', N'', N'Heacock', N'', N'Shenzhen Xinyetong Technology Co.,Ltd', NULL, N'267-620-1171', N'1207', N'267-620-1175', 0, 1, 0, 0, 0, N'2000 AVENUE OF THE STARS, LOS ANGELES', N'', N'', N'US', N'CA', N'LOS ANGELES', N'90067', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'www.etag365.com', N'', NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AD230142F800 AS DateTime), NULL, NULL, N'267-620-1176', N'IT Manager', N'', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AD230142F800 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1038, N'12676201173', N'U00000000019', N'MTI2NzYyMDExNzM=', N'jamal@gastropa.com', N'12676201173', NULL, N'Jamal', N'', N'Heacock', N'', N'Shenzhen Xinyetong Technology Co.,Ltd', NULL, N'267-620-1171', N'0', N'267-620-1175', 0, 1, 0, 0, 0, N'2000 AVENUE OF THE STARS, LOS ANGELES', N'', N'', N'US', N'CA', N'LOS ANGELES', N'90067', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'www.etag365.com', N'3', NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AD230142F800 AS DateTime), NULL, NULL, N'267-620-1176', N'IT Manager', N'', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AD230142F800 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1039, N'12016351269', N'U00000000020', N'MTIwMTYzNTEyNjk=', N'aftab@2rsolution.com', N'12016351269', NULL, N'John', N'', N'Doe', N'', N'ADI', NULL, N'201-481-5542', N'232', N'201-531-2269', 0, 1, 0, 0, 0, N'1222', N'', N'INDIANA', N'US', N'IN', N'test', N'15000', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'', N'Category1', NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AD230142F800 AS DateTime), NULL, NULL, N'', N'', N'Other', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AD230142F800 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1040, N'12153335656', N'U00000000021', N'MTIxNTMzMzU2NTY=', N'aftab@2rsolution.com', N'12153335656', NULL, N'Donna', N'', N'Bell', N'', N'', NULL, N'', N'', N'', 0, 1, 0, 0, 0, N'100 Main street', N'', N'INDIANA', N'US', N'IN', N'test', N'15000', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'www.serverpro.com', N'Category1', NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AD230142F801 AS DateTime), NULL, NULL, N'', N'Serpro', N'Main', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL)
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1041, N'12152335300', N'U00000000022', N'MTIxNTIzMzUzMDA=', N'sbutcher@myfileit.com', N'12152335300', NULL, N'Donna', N'', N'Bell', N'', N'Serpro', NULL, N'215-333-5656', N'1207', N'215-333-5656', 0, 1, 0, 0, 0, N'100 Main street', N'', N'', N'US', N'PA', N'Norristown', N'19045', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'www.serverpro.com', N'Category1', NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AD230142F839 AS DateTime), NULL, NULL, N'215-333-5656', N'', N'Main', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AD230142F839 AS DateTime))
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1042, N'11817708660', N'U00000000023', N'MTIzNA==', NULL, N'11817708660', N'540997', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, N'US', NULL, NULL, NULL, NULL, N'', N'', N'2', 0, 0, 1, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'11817708660', CAST(0x0000ADFA000466F2 AS DateTime), N'11817708660', CAST(0x0000ADFA0004A740 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'1', N'', N'', NULL, NULL)
GO
INSERT [dbo].[UserProfile] ([Id], [Username], [Serial], [Password], [Email], [Phone], [PhoneVerifyCode], [FirstName], [MiddleName], [LastName], [ProfileLogo], [CompanyName], [CompanyLogo], [WorkPhone], [WorkPhoneExt], [Fax], [IsPhoneVerified], [IsNewUser], [IsAgree], [DoNotEmbedProfile], [DoNotEmbedCompany], [Address], [Address1], [Region], [Country], [State], [City], [Zip], [Other], [DatabaseName], [DatabaseLocation], [UserTypeContact], [IsAdmin], [IsDeleted], [IsActive], [CanLogin], [IsUserProfileComplete], [IsBillingComplete], [IsOverwrite], [Website], [Category], [YTD_Contact_Export_Limit], [YTD_Contact_Export], [MTD_Contact_Import], [MTD_Contact_Import_Limit], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [RefPhone], [Title], [TypeOfContact], [SubscriptionType], [SubscriptionExpiredOn], [StorageExpiredOn], [IsStorageSubscription], [LastImportedDate], [LastExportedDate], [Contact_Storage_Limit], [IsSentMail], [CountryCode], [Longitude], [Latitude], [IsEmailFlow], [EmailFlowCreatedOn]) VALUES (1043, N'12021121234', N'U00000000024', N'MTIwMjExMjEyMzQ=', N'a@a.com', N'12021121234', NULL, N'John', N'', N'Doe', N'', N'ABC', NULL, N'NULL', N'NULL', N'NULL', 0, 1, 0, 0, 0, N'100 North Street', N'', N'NY', N'US', N'NY', N'New York', N'19034', N'', NULL, NULL, N'2', 0, 0, 1, 1, 0, 0, 0, N'abc.com', N'Category1', NULL, NULL, NULL, NULL, N'8801817708660', CAST(0x0000AE1B001BA27B AS DateTime), NULL, NULL, N'NULL', N'John Doe', N'Phone', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000AE1B001BA27C AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[UserProfile] OFF
GO
SET IDENTITY_INSERT [dbo].[UserType] ON 

GO
INSERT [dbo].[UserType] ([Id], [UserType], [UserDefineId]) VALUES (1, N'Admin', 1)
GO
INSERT [dbo].[UserType] ([Id], [UserType], [UserDefineId]) VALUES (8, N'Normal', 2)
GO
INSERT [dbo].[UserType] ([Id], [UserType], [UserDefineId]) VALUES (10, N'Dealer', 3)
GO
SET IDENTITY_INSERT [dbo].[UserType] OFF
GO
SET IDENTITY_INSERT [dbo].[Version] ON 

GO
INSERT [dbo].[Version] ([Id], [andVerCode], [andVerLabel], [andMustUpdate], [andVerNote], [andLink], [iOsVerCode], [iOsVerLabel], [iOsMustUpdate], [iOsLink], [iOsVerNote], [CreatedDate]) VALUES (1, N'01', N'1.0.1', 1, N'Critical Bug Fixed. New Features Added.\n\nNote: Please Reinstall the App, if Update button doesn’t work properly.', N'https://etag365.net/', N'01', N'1.0.1', 1, N'https://etag365.net/', N'Brand New Version', CAST(0x0000ABAB001ADCCC AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Version] OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_BillingPayment_IsStorageSubscription]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BillingPayment] ADD  CONSTRAINT [DF_BillingPayment_IsStorageSubscription]  DEFAULT ((0)) FOR [IsStorageSubscription]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_BillingPayment_IsReceivedCommissions]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BillingPayment] ADD  CONSTRAINT [DF_BillingPayment_IsReceivedCommissions]  DEFAULT ((0)) FOR [IsReceivedCommissions]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_BillingPayment_IsBillingCycleMonthly]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BillingPayment] ADD  CONSTRAINT [DF_BillingPayment_IsBillingCycleMonthly]  DEFAULT ((0)) FOR [IsBillingCycleMonthly]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_BillingPayment_IsCommissionMonthly]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BillingPayment] ADD  CONSTRAINT [DF_BillingPayment_IsCommissionMonthly]  DEFAULT ((0)) FOR [IsCommissionMonthly]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_BillingPayment_IsRecurring]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BillingPayment] ADD  CONSTRAINT [DF_BillingPayment_IsRecurring]  DEFAULT ((0)) FOR [IsRecurring]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CalendarSchedule_IsBooked]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CalendarSchedule] ADD  CONSTRAINT [DF_CalendarSchedule_IsBooked]  DEFAULT ((1)) FOR [IsBooked]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ContactInformation_IsEmailFlow]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ContactInformation] ADD  CONSTRAINT [DF_ContactInformation_IsEmailFlow]  DEFAULT ((0)) FOR [IsEmailFlow]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PaymentHistory_IsCheckingAccount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentHistory] ADD  CONSTRAINT [DF_PaymentHistory_IsCheckingAccount]  DEFAULT ((0)) FOR [IsCheckingAccount]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PaymentHistory_IsStorageSubscription]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentHistory] ADD  CONSTRAINT [DF_PaymentHistory_IsStorageSubscription]  DEFAULT ((0)) FOR [IsStorageSubscription]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PaymentHistory_IsReceivedCommissions]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentHistory] ADD  CONSTRAINT [DF_PaymentHistory_IsReceivedCommissions]  DEFAULT ((0)) FOR [IsReceivedCommissions]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PaymentHistory_IsRecurring]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentHistory] ADD  CONSTRAINT [DF_PaymentHistory_IsRecurring]  DEFAULT ((0)) FOR [IsRecurring]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PaymentHistory_IsBillingCycleMonthly]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentHistory] ADD  CONSTRAINT [DF_PaymentHistory_IsBillingCycleMonthly]  DEFAULT ((0)) FOR [IsBillingCycleMonthly]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PaymentInformation_IsCheckingAccount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentInformation] ADD  CONSTRAINT [DF_PaymentInformation_IsCheckingAccount]  DEFAULT ((0)) FOR [IsCheckingAccount]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PaymentInformation_IsCheckingAccount1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentInformation] ADD  CONSTRAINT [DF_PaymentInformation_IsCheckingAccount1]  DEFAULT ((0)) FOR [IsRecurring]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PaymentInformation_IsRecurring1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentInformation] ADD  CONSTRAINT [DF_PaymentInformation_IsRecurring1]  DEFAULT ((0)) FOR [IsAgree]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_REFSTATES_STATE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[States] ADD  CONSTRAINT [DF_REFSTATES_STATE]  DEFAULT ('') FOR [STATE]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_REFSTATES_STATENAME]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[States] ADD  CONSTRAINT [DF_REFSTATES_STATENAME]  DEFAULT ('') FOR [STATENAME]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_REFSTATES_FreightTaxable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[States] ADD  CONSTRAINT [DF_REFSTATES_FreightTaxable]  DEFAULT ('N') FOR [FreightTaxable]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__States__Shipping__5535A963]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[States] ADD  DEFAULT ((0)) FOR [ShippingSurcharge]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__UserLog_D__Statu__5629CD9C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserLog_Data] ADD  DEFAULT ((1)) FOR [Status]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserProfile_HasSystemInfo]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_HasSystemInfo]  DEFAULT ((0)) FOR [IsPhoneVerified]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserProfile_HasSystemInfo1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_HasSystemInfo1]  DEFAULT ((0)) FOR [IsNewUser]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserProfile_HasSystemInfo3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_HasSystemInfo3]  DEFAULT ((0)) FOR [IsAgree]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserProfile_HasContactProfile]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_HasContactProfile]  DEFAULT ((0)) FOR [DoNotEmbedProfile]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserProfile_HasPropertyLocation]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_HasPropertyLocation]  DEFAULT ((0)) FOR [DoNotEmbedCompany]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserProfile_CanLogin]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_CanLogin]  DEFAULT ((0)) FOR [CanLogin]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserProfile_IsStorageSubscription]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_IsStorageSubscription]  DEFAULT ((0)) FOR [IsStorageSubscription]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserProfile_IsAgree1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_IsAgree1]  DEFAULT ((0)) FOR [IsSentMail]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserProfile_IsSentMail1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_IsSentMail1]  DEFAULT ((0)) FOR [IsEmailFlow]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Version_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Version] ADD  CONSTRAINT [DF_Version_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_dbo.Child_dbo.Master_MasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Child]'))
ALTER TABLE [dbo].[Child]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Child_dbo.Master_MasterId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Master] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_dbo.Child_dbo.Master_MasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Child]'))
ALTER TABLE [dbo].[Child] CHECK CONSTRAINT [FK_dbo.Child_dbo.Master_MasterId]
GO
/****** Object:  Trigger [dbo].[TRG_UpdateEmailDrip]    Script Date: 1/12/2023 12:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRG_UpdateEmailDrip]'))
EXEC dbo.sp_executesql @statement = N'CREATE TRIGGER [dbo].[TRG_UpdateEmailDrip] 
ON [eTag365].[dbo].[ContactInformation]
AFTER INSERT, UPDATE   AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @id INT, @Phone varchar(30), @IsEmailFlow smallint

	SELECT @id = [Id] FROM INSERTED
  
	SELECT @IsEmailFlow = ISNULL(IsEmailFlow,0)   FROM [eTag365].[dbo].[ContactInformation] WHERE Id = @id   
	
	SELECT @Phone = ISNULL(Phone,'''')   FROM [eTag365].[dbo].[ContactInformation] WHERE Id = @id 

	if len(@Phone) = 10 
		Begin
			set @Phone = ''1''+ @Phone
		End

	update contactInformation set Phone = @Phone where Id = @id  

	DECLARE @MaxSerial int, @Serial varchar(20), @Password varchar(20), @Username varchar(30)

	select @MaxSerial = cast(cast(RIGHT(max(serial), 11) as int)+1 as int) from UserProfile where UserTypeContact = ''2''

	SELECT @Serial = ''U'' + RIGHT(''00000000000''+CAST(@MaxSerial AS VARCHAR(11)),11)

	set @Username = @Phone

	-- generate Base64 Password for new user

	set @Password = CONVERT(VARCHAR(20), (SELECT CONVERT(VARBINARY, @Phone) FOR XML PATH(''''), BINARY BASE64))
		
	-- Insert User record if not exist

	DECLARE @FirstName varchar(50),@MiddleName varchar(50),@LastName varchar(50),@Email varchar(100),
	@Address nvarchar(150),@Address1 nvarchar(150),@Region varchar(50),@Country varchar(50) ,
	@State varchar(30),@City varchar(30),@Zip varchar(10),
	@WorkPhone varchar(30),@WorkPhoneExt varchar(30),@Fax varchar(30),@IsActive bit ,
	@Category varchar(50),@TypeContact varchar(300), @Website varchar(100),@ProfileLogo varchar(300),
	@Other varchar(300),@Memo varchar(250), @CountryCode varchar(5),
	@CreatedBy varchar(30),@CreatedDate datetime,@RefPhone varchar(30),@CompanyName varchar(100),@Title varchar(100)

	DECLARE db_contact_user CURSOR FOR
		SELECT 	isnull(c.FirstName,'''') FirstName,isnull(c.MiddleName,'''') MiddleName,isnull(c.LastName,'''') LastName,isnull(c.Email,'''') Email,
			isnull(c.Address,'''') Address,isnull(c.Address1,'''') Address1,isnull(c.Region,'''') Region,isnull(c.Country,''US'') Country,
			isnull(c.State,'''') State,isnull(c.City,'''') City,isnull(c.Zip,'''') Zip,isnull(c.Phone,'''') Phone,
			isnull(c.WorkPhone,'''') WorkPhone,isnull(c.WorkPhoneExt,'''') WorkPhoneExt,isnull(c.Fax,'''') Fax,
			isnull(c.IsActive,''1'') IsActive,isnull(createdBy,'''') createdBy,isnull(CreatedDate,GETDATE()) CreatedDate,
			isnull(c.RefPhone,'''') RefPhone,isnull(c.Title,'''') Title,isnull(c.CompanyName,'''') CompanyName,isnull(c.Category,'''') Category,
			isnull(c.TypeOfContact,'''') TypeOfContact,isnull(c.IsEmailFlow,''0'') IsEmailFlow,isnull(c.ProfileLogo,'''') ProfileLogo, 
			isnull(c.Other,'''') Other, isnull(c.Memo,'''') Memo, isnull(c.CountryCode,''1'') CountryCode, isnull(c.Website,'''') Website

			FROM ContactInformation c  where c.Id = @id
			
			OPEN db_contact_user 
			
			FETCH NEXT FROM db_contact_user INTO 
				@FirstName ,@MiddleName ,@LastName ,@Email ,@Address ,@Address1 ,@Region ,@Country,
				@State ,@City ,@Zip ,@Phone ,@WorkPhone ,@WorkPhoneExt,@Fax ,@IsActive,
				@CreatedBy ,@CreatedDate ,@RefPhone ,@Title,@CompanyName,@Category,@TypeContact, @IsEmailFlow,
				@ProfileLogo, @Other,@Memo, @CountryCode, @Website	
			
			WHILE @@FETCH_STATUS =0
			BEGIN			
			
			--- Update User Info ----
			if exists (select * from UserProfile where Phone = @Phone)
				begin
					UPDATE [dbo].[UserProfile]
					SET 
					     [Email] = @Email
						,[FirstName] = @FirstName
						,[MiddleName] = @MiddleName
						,[LastName] = @LastName
						,[ProfileLogo] = @ProfileLogo
						,[CompanyName] = @CompanyName
						,[WorkPhone] = @WorkPhone
						,[WorkPhoneExt] = @WorkPhoneExt
						,[Fax] = @Fax     
						,[Address] = @Address
						,[Address1] = @Address1
						,[Region] = @Region
						,[Country] = @Country
						,[State] = @State
						,[City] =@City
						,[Zip] = @Zip						
						,[Other] = @Other   
						,[Website] = @Website
						,[Category] = @Category
						,[UpdatedBy] = @createdBy
						,[UpdatedDate] = GETDATE()
						,[RefPhone] =@RefPhone
						,[Title] = @Title
						,[TypeOfContact] = @TypeContact	
						,[IsEmailFlow] = @IsEmailFlow
						,[CountryCode] = @CountryCode

					WHERE Phone = @Phone 
						
				end
			else
				begin				

						INSERT INTO [dbo].[UserProfile]
							   ([Username]
							   ,[Serial]
							   ,[Password]
							   ,[Email]
							   ,[Phone]
							   ,[FirstName]
							   ,[MiddleName]
							   ,[LastName]					  
							   ,[Address]
							   ,[Address1]
							   ,[Region]
							   ,[Country]
							   ,[State]
							   ,[City]
							   ,[Zip]					 
							   ,[WorkPhone]
							   ,[WorkPhoneExt]
							   ,[Fax]							 
							   ,[UserTypeContact]
							   ,[CreatedBy]
							   ,[CreatedDate]
							   ,[RefPhone]
							   ,[Title]
							   ,[TypeOfContact]
							   ,[CompanyName]
							   ,[Category]
							   ,[IsEmailFlow]
							   ,[ProfileLogo]
							   ,[IsPhoneVerified]
							   ,[IsNewUser]
							   ,[IsAgree]
							   ,[DoNotEmbedProfile]
							   ,[DoNotEmbedCompany]
							   ,[Other]         
							   ,[IsAdmin]
							   ,[IsDeleted]
							   ,[IsActive]
							   ,[CanLogin]
							   ,[IsUserProfileComplete]
							   ,[IsBillingComplete]
							   ,[IsOverwrite]
							   ,[Website]					  
							   ,[IsSentMail]
								)
							   select @Username, @Serial, @Password,@Email, @Phone, @FirstName,@MiddleName,@LastName,@Address,@Address1,@Region,@Country,@State,@City,@Zip,
							   @WorkPhone,@WorkPhoneExt,@Fax,''2'',@createdBy,GETDATE(),@RefPhone,@Title,@TypeContact,@CompanyName,@Category,@IsEmailFlow,
							   @ProfileLogo, ''0'', ''1'', ''0'', ''0'', ''0'', @Other, ''0'', ''0'', ''1'', ''1'', ''0'', ''0'', ''0'', @Website, ''0''
					
					end
			
			
			FETCH NEXT FROM db_contact_user INTO 
				@FirstName ,@MiddleName ,@LastName ,@Email ,@Address ,@Address1 ,@Region ,@Country,
				@State ,@City ,@Zip ,@Phone ,@WorkPhone ,@WorkPhoneExt,@Fax ,@IsActive,
				@CreatedBy ,@CreatedDate ,@RefPhone ,@Title,@CompanyName,@Category,@TypeContact, @IsEmailFlow,
				@ProfileLogo, @Other,@Memo, @CountryCode, @Website	
			
			END
			CLOSE db_contact_user
			DEALLOCATE db_contact_user

	-- Update User record

	update [eTag365].dbo.UserProfile set IsEmailFlow =  @IsEmailFlow, EmailFlowCreatedOn = getdate()  where Phone = @Phone and @IsEmailFlow = 1

	-- Insert email scheduler

	if @IsEmailFlow = 1 
	
	begin

		DECLARE @UserId varchar(50), @TypeOfContact varchar(300)   --,@Category nvarchar(50), @CreatedBy varchar(30)
		, @PersonName varchar(100), @PersonEmail varchar(50), @FromEmail varchar(50)

		SELECT @UserId = ISNULL(UserId,'''')   FROM [eTag365].[dbo].[ContactInformation] WHERE Id = @id   
	
		SELECT @Category = ISNULL(Category,'''')   FROM [eTag365].[dbo].[ContactInformation] WHERE Id = @id 

		SELECT @TypeOfContact = ISNULL(TypeOfContact,'''')   FROM [eTag365].[dbo].[ContactInformation] WHERE Id = @id 

		SELECT @CreatedBy = ISNULL(Phone,'''')   FROM [eTag365].[dbo].[UserProfile] WHERE Id = @UserId 

		SELECT @PersonName = cast(@id as varchar(100))

		SELECT @PersonEmail = ISNULL(Email,'''')   FROM [eTag365].[dbo].[ContactInformation] WHERE Id = @id 

		SELECT @FromEmail = ISNULL(Email,'''')   FROM [eTag365].[dbo].[UserProfile] WHERE Id = @UserId 

		DECLARE @TemplateNo nvarchar(3) ,@CategoryEmail nvarchar(30) ,@Type nvarchar(300)

		DECLARE db_Schedule CURSOR FOR
		 
		    select isnull(TemplateNo,''0'') TemplateNo, isnull(Category,'''') Category, isnull(Type,'''') Type from EmailSetup where UserId= @UserId and Category = @Category
			
			OPEN db_Schedule 
			
			FETCH NEXT FROM db_Schedule INTO 
				@TemplateNo, @CategoryEmail, @Type 		
			
			WHILE @@FETCH_STATUS =0
			BEGIN	
				--- Add Schedule Info ----
				-- if not exists (select * from EmailSchedule where PersonEmail = @PersonEmail and FromEmail = @FromEmail and LastEmailNumber = @TemplateNo and Category = @CategoryEmail and Type = @Type)

				if not exists (select * from EmailSchedule where PersonName = @PersonName and FromEmail = @FromEmail and LastEmailNumber = @TemplateNo and Category = @CategoryEmail and Type = @Type)
					begin
						  -- Insert into Contact Info
							INSERT INTO [dbo].[EmailSchedule] (PersonName,PersonEmail,FromEmail,IsLoop,Days,LastEmailNumber,CreatedBy,CreatedDate,Category,Type)						   
							 values(@PersonName, @PersonEmail, @FromEmail, 0, ''2'', @TemplateNo, @CreatedBy, GETDATE(), @CategoryEmail, @Type)		 
					end
				
				else 
					begin
						update	EmailSchedule set PersonEmail = @PersonEmail, UpdatedDate = getdate(), UpdatedBy = @CreatedBy  where PersonName = @PersonName and FromEmail = @FromEmail and LastEmailNumber = @TemplateNo and Category = @CategoryEmail and Type = @Type
					End
			
				FETCH NEXT FROM db_Schedule INTO 
					@TemplateNo, @CategoryEmail, @Type 		 
			
			END

			CLOSE db_Schedule
			DEALLOCATE db_Schedule


	End
	   

END
' 
GO
