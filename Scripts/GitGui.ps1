#Generated Form Function
function GenerateForm {
########################################################################
# Code Generated By: SAPIEN Technologies PrimalForms (Community Edition) v1.0.10.0
# Generated On: 26.10.2021 09:50
# Generated By: sorus
########################################################################

#region Import the Assemblies************************************************************
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#endregion Import the Assemblies---------------------------------------------------------

#-----------------------*****************************************************************
#**********************------------------------------------------------------------------
#Generated Form Objects-*****************************************************************
#**********************------------------------------------------------------------------
#-----------------------*****************************************************************

$GitHub_GUI = New-Object System.Windows.Forms.Form
$btn_open_project = New-Object System.Windows.Forms.Button
$btn_cloneGUI = New-Object System.Windows.Forms.Button
$btn_remove_file = New-Object System.Windows.Forms.Button
$btn_open_file = New-Object System.Windows.Forms.Button
$btn_git_add = New-Object System.Windows.Forms.Button
$btn_git_initialise = New-Object System.Windows.Forms.Button
$btn_show_files = New-Object System.Windows.Forms.Button
$btn_show_history = New-Object System.Windows.Forms.Button
$btn_show_status = New-Object System.Windows.Forms.Button
$btn_pull = New-Object System.Windows.Forms.Button
$btn_push = New-Object System.Windows.Forms.Button
$btn_commit = New-Object System.Windows.Forms.Button
$btn_branchGUI = New-Object System.Windows.Forms.Button

$global:lstbox_display_infos = New-Object System.Windows.Forms.ListBox
$txtbox_description = New-Object System.Windows.Forms.TextBox
$global:txtbox_branch = New-Object System.Windows.Forms.TextBox
$global:txtbox_repository = New-Object System.Windows.Forms.TextBox
$global:txtbox_path = New-Object System.Windows.Forms.TextBox
$txtbox_username = New-Object System.Windows.Forms.TextBox
$txtbox_token = New-Object System.Windows.Forms.MaskedTextBox

$label_description = New-Object System.Windows.Forms.Label
$label_branch = New-Object System.Windows.Forms.Label
$label_repository = New-Object System.Windows.Forms.Label
$label_path = New-Object System.Windows.Forms.Label
$label_title = New-Object System.Windows.Forms.Label
$label_username = New-Object System.Windows.Forms.Label
$label_token = New-Object System.Windows.Forms.Label

$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
#endregion Generated Form Objects--------------------------------------------------------
#Other Variables*************************************************************************
[bool]$global:files_loaded = $false
#endregion-------------------------------------------------------------------------------
#functions*******************************************************************************
function global:Get-GitStat {
	$global:lstbox_display_infos.Items.Clear()
	$status = git status
	$global:lstbox_display_infos.Items.AddRange($status)
	$global:files_loaded = $false
}

function global:Show-GitFiles {
	$global:lstbox_display_infos.Items.Clear()
	$repo_content = Get-ChildItem -Name -Recurse $global:txtbox_path.Text
	$global:lstbox_display_infos.Items.AddRange($repo_content)
	$global:files_loaded = $True
}
#endregion functions---------------------------------------------------------------------

#----------------------------------------------------------------------------------------
#*************************---------------------------------------------------------------
#Generated Event Handlers*---------------------------------------------------------------
#*************************---------------------------------------------------------------
#----------------------------------------------------------------------------------------

#region button event handlers************************************************************

#buttons opening other Windows
$btn_branchGUI_clicked= 
{
	Set-Location $PSScriptRoot
	.\GitGui_Branches.ps1
	Set-Location $global:txtbox_path.Text
}

$btn_cloneGUI_clicked= 
{
	Set-Location $PSScriptRoot
	.\Git_Clone_Repository.ps1
}
#----------------------------------------------------------------------------------------

#butten opening folder*******************************************************************
$btn_open_project_clicked= 
{
	$Null = $FolderBrowser.ShowDialog()
	$global:txtbox_path.Text = $FolderBrowser.SelectedPath
	Set-Location $FolderBrowser.SelectedPath
	$PathSplit = $FolderBrowser.SelectedPath.Split("\")
	$global:txtbox_repository.Text = $PathSplit[$PathSplit.Length -1]
	if (($FolderBrowser.SelectedPath | Get-ChildItem -Name -Force).Contains(".git") -eq $True){
		$global:txtbox_branch.Text = git rev-parse --abbrev-ref HEAD 	
	}
	Show-GitFiles
} 
#----------------------------------------------------------------------------------------

#buttons providing information***********************************************************
$btn_show_files_clicked= 
{	
	Show-GitFiles
}

$btn_open_file_clicked= 
{
	if ($global:files_loaded -eq $True) {
		Invoke-Item $global:lstbox_display_infos.SelectedItem	
	}
}

$btn_remove_file_clicked= 
{
	if($global:files_loaded -eq $True){
		$global:lstbox_display_infos.SelectedItem | Remove-Item
		$global:lstbox_display_infos.Items.Clear()
		$repo_content = (Get-ChildItem -Name $global:txtbox_path.Text)
		$global:lstbox_display_infos.Items.AddRange($repo_content)
	}
}

$btn_show_history_clicked= 
{
	$global:lstbox_display_infos.Items.Clear()
	$history = git log 
	$global:lstbox_display_infos.Items.AddRange($history)
	$global:files_loaded = $false
}

$btn_show_status_clicked= 
{
	Get-GitStat
}
#----------------------------------------------------------------------------------------

#buttons for git management**************************************************************
$btn_pull_clicked= 
{
	git fetch
	git pull
	Get-GitStat
}


$btn_git_add_clicked= 
{
	git add *
	Get-GitStat
}

$btn_commit_clicked= 
{
	$global:lstbox_display_infos.Items.Clear()
	$commit_info = git commit -m $txtbox_description.Text
	$global:lstbox_display_infos.Items.AddRange($commit_info)
	$txtbox_description.Text = ''
}

$btn_push_clicked= 
{
	git push	
	Get-GitStat
}

#----------------------------------------------------------------------------------------

#button creating repository on GitHub and initialisng git locally************************
$btn_git_initialise_clicked= 
{

	#region create repo on GitHub********************************************************
	# Use TLS 1.2
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# create authentication header
	$username = $txtbox_username.Text
	$token = $txtbox_token.Text
	$RepoName = $global:txtbox_repository.Text
	$RepoDescription = $txtbox_description
	$Private = $false
	$Homepage = ''
	$HasIssues = $true
	$HasWiki = $true

	#converting username and token into machinge code
	$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$token)));
	#creating header
	$authHeader = @{"Authorization"="Basic $base64AuthInfo"};

	# creating the body of sent information
	$body = @{
		name = $RepoName;
		description = $RepoDescription;
		homepage = $Homepage;
		private = $Private.IsPresent;
		has_issues = $HasIssues.IsPresent;
		has_wiki = $HasWiki.IsPresent;
		has_downloads = $true;
		auto_init = $true;
	} | ConvertTo-Json -Compress; #converting it to Json and compressing it

	$creationUri = 'https://api.github.com/user/repos';
	
	Invoke-RestMethod -Uri $creationUri -Headers $authHeader -Method Post -Body $body;
	$txtbox_description.Clear()
	#endregion---------------------------------------------------------------------------

	#region initialising Git locally*****************************************************
	#initialise Git repository in selected folder
	$repo_url = "https://github.com/" + $username + "/" + $global:txtbox_repository.Text
	git init -b main
	$global:txtbox_branch.Text = git rev-parse --abbrev-ref HEAD 	
	git remote add origin $repo_url
	git pull --set-upstream origin main
	git add *
	git commit -m "initial commit"
	git push 
	git pull
}
	#endregion---------------------------------------------------------------------------
#endregion button event handlers---------------------------------------------------------


#region KeyDown event handlers***********************************************************

#KeyDown event enabling entering path directly into txtbox
$txtbox_path_KeyDown={
	if ($_.Keycode -eq "Enter" -and $global:txtbox_path.Text -ne ""){
		Set-Location $global:txtbox_path.Text
		$PathSplit = $global:txtbox_path.Text.Split("\")
		$global:txtbox_repository.Text = $PathSplit[$PathSplit.Length -1]
		$global:txtbox_branch.Text = git rev-parse --abbrev-ref HEAD 	
		Show-GitFiles	
	}
}

#endregion KeyDown event handlers--------------------------------------------------------


#----------------------------------------------------------------------------------------
#*************************************************---------------------------------------
#Definition and initialisation of WinForm Objects*---------------------------------------
#*************************************************---------------------------------------
#----------------------------------------------------------------------------------------


$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$GitHub_GUI.WindowState = $InitialFormWindowState
}

#----------------------------------------------
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 412
$System_Drawing_Size.Width = 982
$GitHub_GUI.ClientSize = $System_Drawing_Size
$GitHub_GUI.DataBindings.DefaultDataSourceUpdateMode = 0
$GitHub_GUI.FormBorderStyle = 1
$GitHub_GUI.Name = "GitHub_GUI"
$GitHub_GUI.Text = "GitHub GUI"

#region btn_open_project*****************************************************************
$btn_open_project.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 22
$System_Drawing_Point.Y = 73
$btn_open_project.Location = $System_Drawing_Point
$btn_open_project.Name = "btn_open_project"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 38
$System_Drawing_Size.Width = 102
$btn_open_project.Size = $System_Drawing_Size
$btn_open_project.TabIndex = 24
$btn_open_project.Text = "Open Project"
$btn_open_project.UseVisualStyleBackColor = $True
$btn_open_project.add_Click($btn_open_project_clicked)

$GitHub_GUI.Controls.Add($btn_open_project)
#endregion-------------------------------------------------------------------------------

#region btn_clone_project****************************************************************
$btn_cloneGUI.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 143
$System_Drawing_Point.Y = 73
$btn_cloneGUI.Location = $System_Drawing_Point
$btn_cloneGUI.Name = "btn_clone_project"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 39
$System_Drawing_Size.Width = 96
$btn_cloneGUI.Size = $System_Drawing_Size
$btn_cloneGUI.TabIndex = 23
$btn_cloneGUI.Text = "Clone Project"
$btn_cloneGUI.UseVisualStyleBackColor = $True
$btn_cloneGUI.add_Click($btn_cloneGUI_clicked)

$GitHub_GUI.Controls.Add($btn_cloneGUI)
#endregion btn_clone_project-------------------------------------------------------------


#region btn_remove_file******************************************************************
$btn_remove_file.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 854
$System_Drawing_Point.Y = 198
$btn_remove_file.Location = $System_Drawing_Point
$btn_remove_file.Name = "btn_remove_file"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 30
$System_Drawing_Size.Width = 102
$btn_remove_file.Size = $System_Drawing_Size
$btn_remove_file.TabIndex = 22
$btn_remove_file.Text = "Delete"
$btn_remove_file.UseVisualStyleBackColor = $True
$btn_remove_file.add_Click($btn_remove_file_clicked)

$GitHub_GUI.Controls.Add($btn_remove_file)
#endregion btn_remove_file---------------------------------------------------------------

#region btn_open_file********************************************************************
$btn_open_file.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 854
$System_Drawing_Point.Y = 151
$btn_open_file.Location = $System_Drawing_Point
$btn_open_file.Name = "btn_open_file"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 32
$System_Drawing_Size.Width = 102
$btn_open_file.Size = $System_Drawing_Size
$btn_open_file.TabIndex = 21
$btn_open_file.Text = "Open"
$btn_open_file.UseVisualStyleBackColor = $True
$btn_open_file.add_Click($btn_open_file_clicked)

$GitHub_GUI.Controls.Add($btn_open_file)
#endregion btn_open_file-----------------------------------------------------------------


#region btn_git_add**********************************************************************
$btn_git_add.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 379
$System_Drawing_Point.Y = 200
$btn_git_add.Location = $System_Drawing_Point
$btn_git_add.Name = "btn_git_add"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 27
$System_Drawing_Size.Width = 149
$btn_git_add.Size = $System_Drawing_Size
$btn_git_add.TabIndex = 20
$btn_git_add.Text = "Git Add"
$btn_git_add.UseVisualStyleBackColor = $True
$btn_git_add.add_Click($btn_git_add_clicked)

$GitHub_GUI.Controls.Add($btn_git_add)
#endregion btn_git_add-------------------------------------------------------------------

#region btn_git_initialise***************************************************************
$btn_git_initialise.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 260
$System_Drawing_Point.Y = 73
$btn_git_initialise.Location = $System_Drawing_Point
$btn_git_initialise.Name = "btn_git_initialise"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 38
$System_Drawing_Size.Width = 149
$btn_git_initialise.Size = $System_Drawing_Size
$btn_git_initialise.TabIndex = 19
$btn_git_initialise.Text = "Initialise Git here"
$btn_git_initialise.UseVisualStyleBackColor = $True
$btn_git_initialise.add_Click($btn_git_initialise_clicked)

$GitHub_GUI.Controls.Add($btn_git_initialise)
#endregion btn_git_initialise------------------------------------------------------------

#region btn_show_files*******************************************************************
$btn_show_files.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 556
$System_Drawing_Point.Y = 117
$btn_show_files.Location = $System_Drawing_Point
$btn_show_files.Name = "btn_show_files"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 86
$btn_show_files.Size = $System_Drawing_Size
$btn_show_files.TabIndex = 18
$btn_show_files.Text = "Show Files"
$btn_show_files.UseVisualStyleBackColor = $True
$btn_show_files.add_Click($btn_show_files_clicked)

$GitHub_GUI.Controls.Add($btn_show_files)
#endregion btn_show_files----------------------------------------------------------------


#region btn_show_history*****************************************************************
$btn_show_history.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 658
$System_Drawing_Point.Y = 117
$btn_show_history.Location = $System_Drawing_Point
$btn_show_history.Name = "btn_show_history"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 86
$btn_show_history.Size = $System_Drawing_Size
$btn_show_history.TabIndex = 17
$btn_show_history.Text = "History"
$btn_show_history.UseVisualStyleBackColor = $True
$btn_show_history.add_Click($btn_show_history_clicked)

$GitHub_GUI.Controls.Add($btn_show_history)
#endregion btn_show_history--------------------------------------------------------------

#region btn_show_status******************************************************************
$btn_show_status.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 762
$System_Drawing_Point.Y = 117
$btn_show_status.Location = $System_Drawing_Point
$btn_show_status.Name = "btn_show_status"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 86
$btn_show_status.Size = $System_Drawing_Size
$btn_show_status.TabIndex = 16
$btn_show_status.Text = "Status"
$btn_show_status.UseVisualStyleBackColor = $True
$btn_show_status.add_Click($btn_show_status_clicked)

$GitHub_GUI.Controls.Add($btn_show_status)
#endregion btn_show_status---------------------------------------------------------------


#region lstbox_display_info**************************************************************
$global:lstbox_display_infos.DataBindings.DefaultDataSourceUpdateMode = 0
$global:lstbox_display_infos.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 556
$System_Drawing_Point.Y = 151
$global:lstbox_display_infos.Location = $System_Drawing_Point
$global:lstbox_display_infos.Name = "lstbox_display_infos"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 238
$System_Drawing_Size.Width = 292
$global:lstbox_display_infos.Size = $System_Drawing_Size
$global:lstbox_display_infos.TabIndex = 15

$GitHub_GUI.Controls.Add($global:lstbox_display_infos)
#endregion lstbox_display_infos----------------------------------------------------------

#region label_description****************************************************************
$label_description.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 130
$System_Drawing_Point.Y = 189
$label_description.Location = $System_Drawing_Point
$label_description.Name = "label_description"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 13
$System_Drawing_Size.Width = 157
$label_description.Size = $System_Drawing_Size
$label_description.TabIndex = 14
$label_description.Text = "Commit/Repo Description:"

$GitHub_GUI.Controls.Add($label_description)
#endregion label_description-------------------------------------------------------------

#region btn_pull*************************************************************************
$btn_pull.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 303
$btn_pull.Location = $System_Drawing_Point
$btn_pull.Name = "btn_pull"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 29
$System_Drawing_Size.Width = 107
$btn_pull.Size = $System_Drawing_Size
$btn_pull.TabIndex = 13
$btn_pull.Text = "Pull Project"
$btn_pull.UseVisualStyleBackColor = $True
$btn_pull.add_Click($btn_pull_clicked)

$GitHub_GUI.Controls.Add($btn_pull)
#endregion btn_pull----------------------------------------------------------------------


#region txtbox_description***************************************************************
$txtbox_description.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 130
$System_Drawing_Point.Y = 205
$txtbox_description.Location = $System_Drawing_Point
$txtbox_description.Name = "txtbox_description"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 204
$txtbox_description.Size = $System_Drawing_Size
$txtbox_description.TabIndex = 12

$GitHub_GUI.Controls.Add($txtbox_description)
#endregion txtbox_description------------------------------------------------------------

#region btn_push*************************************************************************
$btn_push.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 254
$btn_push.Location = $System_Drawing_Point
$btn_push.Name = "btn_push"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 33
$System_Drawing_Size.Width = 107
$btn_push.Size = $System_Drawing_Size
$btn_push.TabIndex = 11
$btn_push.Text = "Push Project"
$btn_push.UseVisualStyleBackColor = $True
$btn_push.add_Click($btn_push_clicked)

$GitHub_GUI.Controls.Add($btn_push)
#endregion btn_push----------------------------------------------------------------------

#region btn_commit***********************************************************************
$btn_commit.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 189
$btn_commit.Location = $System_Drawing_Point
$btn_commit.Name = "btn_commit"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 38
$System_Drawing_Size.Width = 107
$btn_commit.Size = $System_Drawing_Size
$btn_commit.TabIndex = 10
$btn_commit.Text = "Commit"
$btn_commit.UseVisualStyleBackColor = $True
$btn_commit.add_Click($btn_commit_clicked)

$GitHub_GUI.Controls.Add($btn_commit)
#endregion btn_commit--------------------------------------------------------------------


#region btn_branchGUI********************************************************************
$btn_branchGUI.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 443
$System_Drawing_Point.Y = 117
$btn_branchGUI.Location = $System_Drawing_Point
$btn_branchGUI.Name = "btn_open_select_branch"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 85
$btn_branchGUI.Size = $System_Drawing_Size
$btn_branchGUI.TabIndex = 9
$btn_branchGUI.Text = "Select Branch"
$btn_branchGUI.UseVisualStyleBackColor = $True
$btn_branchGUI.add_Click($btn_branchGUI_clicked)

$GitHub_GUI.Controls.Add($btn_branchGUI)
#endregion btn_branchGUI-----------------------------------------------------------------


#region txtbox_branch********************************************************************
$global:txtbox_branch.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 393
$System_Drawing_Point.Y = 154
$global:txtbox_branch.Location = $System_Drawing_Point
$global:txtbox_branch.Name = "txtbox_branch"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 135
$global:txtbox_branch.Size = $System_Drawing_Size
$global:txtbox_branch.TabIndex = 8
$global:txtbox_branch.ReadOnly = $True

$GitHub_GUI.Controls.Add($global:txtbox_branch)
#endregion txtbox_branch-----------------------------------------------------------------


#region label_branch*********************************************************************
$label_branch.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 389
$System_Drawing_Point.Y = 121
$label_branch.Location = $System_Drawing_Point
$label_branch.Name = "label_branch"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 30
$System_Drawing_Size.Width = 56
$label_branch.Size = $System_Drawing_Size
$label_branch.TabIndex = 7
$label_branch.Text = "Branch:"

$GitHub_GUI.Controls.Add($label_branch)
#endregion label_branch------------------------------------------------------------------


#region label_username*******************************************************************
$label_username.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 131
$System_Drawing_Point.Y = 247
$label_username.Location = $System_Drawing_Point
$label_username.Name = "label_username"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 16
$System_Drawing_Size.Width = 203
$label_username.Size = $System_Drawing_Size
$label_username.TabIndex = 6
$label_username.Text = "Username:"

$GitHub_GUI.Controls.Add($label_username)
#endregion label_username----------------------------------------------------------------

#region txtbox_username******************************************************************
$txtbox_username.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 131
$System_Drawing_Point.Y = 265
$txtbox_username.Location = $System_Drawing_Point
$txtbox_username.Name = "txtbox_username"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 203
$txtbox_username.Size = $System_Drawing_Size
$txtbox_username.TabIndex = 8

$GitHub_GUI.Controls.Add($txtbox_username)
#endregion txtbox_username--------------------------------------------------------------

#region label_token*********************************************************************
$label_token.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 131
$System_Drawing_Point.Y = 292
$label_token.Location = $System_Drawing_Point
$label_token.Name = "label_token"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 16
$System_Drawing_Size.Width = 203
$label_token.Size = $System_Drawing_Size
$label_token.TabIndex = 6
$label_token.Text = "Personal Access Token:"

$GitHub_GUI.Controls.Add($label_token)
#endregion label_token-----------------------------------------------------------------

#region txtbox_token*******************************************************************
$txtbox_token.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 131
$System_Drawing_Point.Y = 311
$txtbox_token.Location = $System_Drawing_Point
$txtbox_token.Name = "txtbox_token"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 203
$txtbox_token.Size = $System_Drawing_Size
$txtbox_token.TabIndex = 8
$txtbox_token.PasswordChar = '*'

$GitHub_GUI.Controls.Add($txtbox_token)
#endregion txtbox_token----------------------------------------------------------------

#region textbox_repository*************************************************************
$global:txtbox_repository.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 218
$System_Drawing_Point.Y = 154
$global:txtbox_repository.Location = $System_Drawing_Point
$global:txtbox_repository.Name = "txtbox_repository"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 154
$global:txtbox_repository.Size = $System_Drawing_Size
$global:txtbox_repository.TabIndex = 5
$global:txtbox_repository.ReadOnly = $True

$GitHub_GUI.Controls.Add($global:txtbox_repository)
#endregion txtbox_repository-----------------------------------------------------------

#region label_repository***************************************************************
$label_repository.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 214
$System_Drawing_Point.Y = 124
$label_repository.Location = $System_Drawing_Point
$label_repository.Name = "label_repository"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 27
$System_Drawing_Size.Width = 159
$label_repository.Size = $System_Drawing_Size
$label_repository.TabIndex = 4
$label_repository.Text = "Repository:"

$GitHub_GUI.Controls.Add($label_repository)
#endregion label_repository-----------------------------------------------------------

#region label_path********************************************************************
$label_path.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 21
$System_Drawing_Point.Y = 125
$label_path.Location = $System_Drawing_Point
$label_path.Name = "label_path"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 154
$label_path.Size = $System_Drawing_Size
$label_path.TabIndex = 3
$label_path.Text = "Path:"

$GitHub_GUI.Controls.Add($label_path)

#endregion label_path----------------------------------------------------------------

#region txtbox_path******************************************************************

$global:txtbox_path.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 21
$System_Drawing_Point.Y = 154
$global:txtbox_path.Location = $System_Drawing_Point
$global:txtbox_path.Name = "txtbox_path"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 184
$global:txtbox_path.Size = $System_Drawing_Size
$global:txtbox_path.add_Keydown($txtbox_path_KeyDown)
$global:txtbox_path.TabIndex = 2

$GitHub_GUI.Controls.Add($global:txtbox_path)

#endregion txtbox_path--------------------------------------------------------------

#region label_title*****************************************************************

$label_title.DataBindings.DefaultDataSourceUpdateMode = 0
$label_title.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",30,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 14
$label_title.Location = $System_Drawing_Point
$label_title.Name = "label_title"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 48
$System_Drawing_Size.Width = 234
$label_title.Size = $System_Drawing_Size
$label_title.TabIndex = 1
$label_title.Text = "GitHub GUI"

$GitHub_GUI.Controls.Add($label_title)
#endregion label_title--------------------------------------------------------------

#Save the initial state of the form
$InitialFormWindowState = $GitHub_GUI.WindowState
#Init the OnLoad event to correct the initial state of the form
$GitHub_GUI.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$GitHub_GUI.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm
