USE [eTag365]
GO
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
					declare @ReferalUserBillPayDate datetime,@SubscriptionType varchar(30),@packageamount decimal(18,2),@MonthlycommissionAmount decimal(18,4)
					,@commissionCountedMonth int,@achivedcommitionMonthCount int,@ReferalEndDate datetime
					--- core login here----
					select @ReferalUserBillPayDate=b.CreateDate, @packageamount = b.GrossAmount, @SubscriptionType = b.SubscriptionType,@ReferalEndDate=b.ReferralEndDate from BillingPayment b where b.UserPhone=@GiverPhone
					if CONVERT(VARCHAR(26), @ReferalUserBillPayDate, 23) <= CONVERT(VARCHAR(26), DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)), 23) 
					begin
					-- now get subscriptiontype, subscriptionamount				
						--if @SubscriptionType = 'Basic'
						--	begin
						--		select @packageamount=MonthlyCosts from UserPricing where Id=1
						--	end
						--else if(@SubscriptionType = 'Silver')
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
						--select @achivedcommitionMonthCount = COUNT(id) from ReferralTransaction where GetterPhone=@PhoneNo and GiverPhone=@GiverPhone and CommissionFor='Dealer'
					
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

									set @commissiondate = convert(datetime, (cast(@BillYear as varchar(10)) + '-' + cast(@ReferalUserBillPayDateMonthCount as varchar(10)) + '-01'));
									set @note = 'dealer commission added for ' + cast(DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1) as varchar(20)) + ' ' + cast(@BillYear as varchar(10))

								if not EXISTS (select id from ReferralTransaction r where CommissionFor='Dealer' and GetterPhone=@PhoneNo and GiverPhone=@GiverPhone and r.Month = DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1) and @commissionYear=YEAR(@ReferalUserBillPayDate))
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
										--select @GiverPhone,@PhoneNo,getdate(),@MonthlycommissionAmount,DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1),YEAR(GETDATE()),'commission added',GETDATE(),DATEADD(month, -1, getdate()),0,'Dealer',@ZipCode
										select @GiverPhone,@PhoneNo,DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)),@MonthlycommissionAmount,DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1),@BillYear,'dealer commission added',@note,GETDATE(),@commissiondate,0,'Dealer',@ZipCode

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