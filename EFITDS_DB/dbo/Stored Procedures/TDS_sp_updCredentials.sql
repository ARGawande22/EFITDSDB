

CREATE    Procedure [dbo].[TDS_sp_updCredentials]
	@officeId int,
	@credentialId int,
	@UpdatedBy int,
	@userId Nvarchar(20),
	@password Nvarchar(255),
	@status Char(1)

--***********************************************************
--*** Pyrpose: Update the Client credential i.e Sevaarth, DDO, Traces.
--***
--*** Created On 12 Apr 2025 By A.R.Gawande
--***
--***********************************************************
AS
BEGIN

	SET NOCOUNT ON 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON

	DECLARE @ErrMsg Nvarchar(255),
			@GetDate Datetime

	--Get Current Date
	Select @GetDate=Getdate()	

	IF EXISTS(SELECT Id FROM [dbo].[TDS_t_Office_Credentials] WHERE Office_Id=@officeId AND Credential_Id=@credentialId)
	BEGIN
		--Update the Client Credentials.
		UPDATE [dbo].[TDS_t_Office_Credentials]
		SET [User_Id]=@userId,
			[Password]=@password,
			[Status]=@status
		WHERE Office_Id=@officeId
			  AND Credential_Id=@credentialId

		IF(@@ROWCOUNT=0)
		BEGIN
			Select @ErrMsg='Error updating client credential for userId:- '+CAST(@userId as VARCHAR)
			GOTO spError
		END
	END
	ELSE
	BEGIN
		-- Insert New Credential If nt exists
		INSERT INTO [dbo].[TDS_t_Office_Credentials]
					([Office_Id]
					,[Credential_Id]
					,[User_Id]
					,[Password]
					,[Status]
					)
			  VALUES(@officeId
					,@credentialId
					,@userId
					,@password
					,@status)

		IF(@@ROWCOUNT=0)
		BEGIN
			Select @ErrMsg='Error inserting client credential for userId:- '+CAST(@userId as VARCHAR)
			GOTO spError
		END
	END	

	RETURN(0)

spError:
	IF(ISNULL(DATALENGTH(@ErrMsg),0))>0
	BEGIN
		SELECT @ErrMsg=@ErrMsg
		RAISERROR(@ErrMsg,18,1)
	END

	RETURN(-1)
END
