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
						,@MonthlycommissionAmount decimal(18,4), @commissionCountedMonth int
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

									set @commissiondate = convert(datetime, (cast(@BillYear as varchar(10)) + '-' + cast(@ReferalUserBillPayDateMonthCount as varchar(10)) + '-01'));
									set @note = 'commission added for ' + cast(DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1) as varchar(20)) + ' ' + cast(@BillYear as varchar(10))

									if not EXISTS (select id from ReferralTransaction r where CommissionFor='User' and GetterPhone=@PhoneNo and GiverPhone=@GiverPhone and r.Month = DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1) and @commissionYear=YEAR(@ReferalUserBillPayDate) )
										begin
											INSERT INTO [dbo].[ReferralTransaction]
											   ([GiverPhone]
											   ,[GetterPhone]
											   ,[TransactionDate]
											   ,[PayorAmount]
											   ,[Month]
											   ,[Year]
											   ,[Remarks]
											   ,[Description]
											   ,[CreatedDate]
											   ,[CommissionMonthDate]
											   ,IsPaid
											   ,CommissionFor)
												select @GiverPhone,@PhoneNo,DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)),@MonthlycommissionAmount,DateName(month,DateAdd(month ,@ReferalUserBillPayDateMonthCount , 0) - 1),@BillYear,'commission added',@note,GETDATE(),@commissiondate,0,'User'

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

						set @YTDcommissionOwed =(select isnull(sum(PayorAmount),0) from ReferralTransaction where CommissionFor='User' and GetterPhone=@PhoneNo and GiverPhone=@GiverPhone)
					
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
