#Generated Form Function
function GenerateForm {
########################################################################
# Project Name: Git Gui
# Design by: Daniel Greil, Sorusch Afkhami
# Code by: Daniel Greil
########################################################################

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#endregion

#region Generated Form Objects
# Form
$GitHub_GUI = New-Object System.Windows.Forms.Form

# Buttons
$btn_open_project = New-Object System.Windows.Forms.Button
$btn_new_project = New-Object System.Windows.Forms.Button
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
$btn_open_select_branch = New-Object System.Windows.Forms.Button

# Listboxes
$listbox_display_infos = New-Object System.Windows.Forms.ListBox

# Labels
$label_commit_description = New-Object System.Windows.Forms.Label
$label_branch = New-Object System.Windows.Forms.Label
$label_repository = New-Object System.Windows.Forms.Label
$label_path = New-Object System.Windows.Forms.Label
$label_title = New-Object System.Windows.Forms.Label

# Textboxes
$txtbox_commit_description = New-Object System.Windows.Forms.TextBox
$txtbox_projectPath = New-Object System.Windows.Forms.TextBox
$txtbox_repository = New-Object System.Windows.Forms.TextBox
$txtbox_branch = New-Object System.Windows.Forms.TextBox

$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

# Variables that are Script or Globally
#-------------------------------------------------------------
$Global:GlobalPath = ""

$Script:isProjectPathEmpty = $true

#-------------------------------------------------------------


# Functions

#-------------------------------------------------------------
# createMessagebox
#
# Description: 
# Creation of Messagebox using parameters
#
# Parameters: BoxTitle, MessageTitle, Description
#
#-------------------------------------------------------------
function Global:createMessagebox($BoxTitle, $MessageTitle, $Description) {
	[System.Windows.Forms.MessageBox]::Show($MessageTitle + $([System.Environment]::NewLine) + $Description, $BoxTitle,0,[System.Windows.Forms.MessageBoxIcon]::Exclamation)
}

#-------------------------------------------------------------
# updatePath
#
# Description: 
# Updating Global Variable with Path in TxtBox
#
# Parameters: none
#
#
#-------------------------------------------------------------
function Global:updatePath {
	# Check if the path is valid
	isPathValid

	if ($Script:isProjectPathValid -eq $true) {
		$Global:GlobalPath = $txtbox_projectPath.Text
		Set-Location $Global:GlobalPath
	}
}

#-------------------------------------------------------------
# UpdateTxtBox
#
# Description: 
# Updating Txtboxes of ProjectPath, RepositoryName and 
# Git Header Name
#
# Parameters: PathName
# PathName = Name of the Path to Update Txtboxes
# 
#
#-------------------------------------------------------------
function UpdateTxtBox($PathName) {
	# Needed because of the git Command
	Set-Location "$PathName"

	# Command needed to get Branch header
	$BranchCommand = git rev-parse --abbrev-ref HEAD

	# Update project path txtbox
	$txtbox_projectPath.Text = $PathName

	# Set Txtbox repository to base Repository
	$txtbox_repository.Text = ([System.IO.FileInfo]$PathName).BaseName

	# Change Page Header
	if ($BranchCommand -contains "fatal: not a git repository (or any of the parent directories): .git") {
		$txtbox_branch.Text = "No Header found"
	} else {
		$txtbox_branch.Text = $BranchCommand
	}
}


#-------------------------------------------------------------
# ClearGitFields
#
# Description: 
# Updating Updating
#
# Parameters: SelectedPath
# SelectedPath = Path in txt that Project should in
# 
#
#-------------------------------------------------------------
function ClearGitFields {
	# Listbox
	$listbox_display_infos.Items.Clear()
	# Project Path
	$txtbox_projectPath.Text = ""
	# Commit Message
	$txtbox_commit_description.Text = ""
	# Repository
	$txtbox_repository.Text = ""
	# Branch
	$txtbox_branch.Text = ""
}

#-------------------------------------------------------------
# isPathValid
#
# Description: 
# check if a path is valid
#
# Parameters: none 
#
# Return: Boolean, $Script:isProjectPathValid
#
#-------------------------------------------------------------
function isPathValid {
	# Check if Path is empty
	if ($txtbox_projectPath.Text -ne "") {
		#check if path is valid
		if (Test-Path $txtbox_projectPath.Text) {
			# Path is Valid
			$Script:isProjectPathValid = $true
		} else {
			# Path doesn't exist
			createMessagebox "Fehler" "Der angegebende Pfad existiert nicht" "Bitte geben Sie einen Validen Path ein"
			$Script:isProjectPathValid = $false
		}
	} else {
		# Path empty
		createMessagebox "Fehler" "Pfad Feld ist Leer" "Bitte geben Sie einen validen Pfad ein"
		$Script:isProjectPathValid = $false
	}
	
}

#-------------------------------------------------------------
# ChangeButtonVisibility
#
# Description: 
# Changes Visibility of the Buttons $btn_open_file and
# $btn_remove_file
#
# Parameters: $SwitchedTab 
# $SwitchedTab = 'Tab' the user switched to
#
#-------------------------------------------------------------
function ChangeButtonVisibility($SwitchedTab) {
	# options for  $SwitchedTab: "ShowFiles", "History" and "Status"
	switch ($SwitchedTab) {
		"ShowFiles" {
			$btn_open_file.Visible = $true
			$btn_remove_file.Visible = $true
		}
		"History" {
			$btn_open_file.Visible = $false
			$btn_remove_file.Visible = $false
		}
		"Status" {
			$btn_open_file.Visible = $false
			$btn_remove_file.Visible = $false
		}
	}
}

#-------------------------------------------------------------
# ControlListboxDisplay
#
# Description: 
# Changes what the listbox Displays
#
# Parameters: $DisplaysMode
# $DisplayMode = How the listbox should be shown
#
#-------------------------------------------------------------
function ControlListboxDisplay($DisplayMode) {
	
	# Update PojectPath 
	# needed because clean code
	updatePath

	# Check if the Path is Valid
	if ($Script:isProjectPathValid -eq $true) {
		# Change The Button Visibility
		ChangeButtonVisibility $DisplayMode

		# clear Listbox
		$listbox_display_infos.Items.Clear()

		# Check to see if Path is valid
		if (Test-Path $Global:GlobalPath) {
			switch ($DisplayMode) {
				"ShowFiles" { 
					foreach ($line in Get-ChildItem) {
						$listbox_display_infos.Items.Add($line)
					}
				 }
				"History" {
					foreach ($line in git log) {
						$listbox_display_infos.Items.Add($line)
					}
				 }
				"Status" {
					foreach ($Line in git status) {
						$listbox_display_infos.Items.Add($Line)
					}
				}
			}
		} else {
			$listbox_display_infos.Items.Clear()
		}
	}
}

# Below description of what should happen

# Open Select ProjectFolder Window
$btn_open_project_clicked= 
{
	# Clear the txtbox field first
	ClearGitFields

	# Select a Folder
	$OpenFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $OpenFolderDialog.ShowDialog() | Out-Null

	# Update txtboxes if result is not empty
	if ($OpenFolderDialog.SelectedPath -ne "") {
		UpdateTxtBox($OpenFolderDialog.SelectedPath)
	}
}

# Open Clone Project window
$btn_new_project_clicked= 
{
	# Open Antother Script Instance
	& "$PSScriptRoot\GitGui_Clone_Repository.ps1"

	# Update all the necessary text boxes
	UpdateTxtBox($Global:GlobalPath)
}

# Create a git Repository in Current Folder
$btn_git_initialise_clicked= 
{
	createMessagebox "Kein Fehler" "Nicht verfügbar" "Dieses Feature ist im Moment noch in Bearbeitung"
	# update the Path
	updatePath
	if ($Script:isProjectPathValid -eq $true) {
		# check if path is empty
		if ((Get-ChildItem -Force $Global:GlobalPath).Count -eq 0) {
			New-Item -path "./README.md" -Value "This is a Test"	
		}

		# check if dir is git dir
		if (((Get-ChildItem -Force $Global:GlobalPath).Name).Contains(".git")) {
			createMessagebox "Fehler" "Ordner ist bereits Git Repository" "Sie müssen einen Ordner auswählen, der kein Git repro ist"
		} else {
			# Erstellt projekt. und commited es
			git init -b main
			git add *
			git commit -m "Project has been created"

			# Gib den Branch an
			$txtbox_branch.Text = git rev-parse --abbrev-ref HEAD
		}
	}
}

# Open Select Branch window
$btn_open_select_branch_clicked=
{
	updatePath

	# Check if ProjectPath is empty
	if ($Script:isProjectPathValid -eq $true) {
		# Open Antother Script Instance
		& "$PSScriptRoot/GitGui_Branches.ps1"
		UpdateTxtBox($Global:GlobalPath)
	}
}


#_______________________________________________________________


# List all files in current directory
$btn_show_files_clicked=
{
	ControlListboxDisplay("ShowFiles")
}

# Show History of Project in Listbox
$btn_show_history_clicked= 
{
	if (((Get-ChildItem -Force $Global:GlobalPath).Name).Contains(".git")) {
		ControlListboxDisplay("History")
	} else {
		createMessagebox "Fehler" "Sie müssen ein git repository angeben" "Angegebener Pfad ist kein Git Repository"
	}
}

# Show status of Project in Listbox
$btn_show_status_clicked= 
{
	if (((Get-ChildItem -Force $Global:GlobalPath).Name).Contains(".git")) {
		ControlListboxDisplay("Status")
	} else {
		createMessagebox "Fehler" "Sie müssen ein git repository angeben" "Angegebener Pfad ist kein Git Repository"
	}
}


#_______________________________________________________________


# Open selected File in Listbox
$btn_open_file_clicked=
{
	# Update the Path
	updatePath

	# Check if ProjectPath is empty
	if ($Script:isProjectPathValid -eq $true) {	
		$SelectedItem = $listbox_display_infos.SelectedItems

		#Check to see if an item was selected
		if ($SelectedItem.Count -gt 0) {
			write-host $SelectedItem
			# Check if Item is a File or Folder
			if (Test-Path "./$SelectedItem" -PathType Leaf) {
				# Item is File
				Start-Process powershell.exe -NoNewWindow -ArgumentList ("./" + $SelectedItem) -PassThru
			} else {
				# Item is Folder
				createMessagebox "Fehler" "Dies ist ein Ordner" "Gehen Sie sicher, dass Sie eine Datei wählen"
			}	
		} else {
			# There was no item Selected
			createMessagebox "Fehler" "Wählen Sie zuerst ein Element aus" ""
		}
		
	}
}

# Delete File from Listbox
$btn_remove_file_clicked=
{
	# Check if ProjectPath is empty
	if ($Script:isProjectPathValid -eq $true) {
		# Set the Selected Item
		$SelectedItem = $listbox_display_infos.SelectedItem

		#Check to see if an item was selected
		if ($SelectedItem.Count -gt 0) {
			# Remove Item 
			Remove-Item "./$SelectedItem" -Recurse
		}  else {
			# There was no item Selected
			createMessagebox "Fehler" "Wählen Sie zuerst ein Element aus" ""
		}
	}
	# Refresh the Listbox
	ControlListboxDisplay("ShowFiles")
}


#_______________________________________________________________


# Commit Project
$btn_commit_clicked= 
{
	# Update the Path
	updatePath

	# Check to see if path Valid
	if($Script:isProjectPathValid -eq $true) {
		# Check if Dir is git directory
		if (((Get-ChildItem -Force $Global:GlobalPath).Name).Contains(".git")) {
			# Chech if description is not empty
			if ($txtbox_commit_description.Text -ne "") {
				# Commit
				git commit -m $txtbox_commit_description
				createMessagebox "Erfolg" (git commit -m $txtbox_commit_description | Out-String) " "
			} else {
				# No Description is found
				createMessagebox "Fehler" "Sie müssen eine Beschreibung hinzufügen." "Um das project commiten zu können, müssen Sie eine Nachticht angeben"
			}
		} else {
			# Kein git repro
			createMessagebox "Fehler" "Sie müssen ein git repository angeben" "Angegebener Pfad ist kein Git Repository"
		}
	}
}

# pull project
$btn_pull_clicked= 
{
	# Update the Path
	updatePath

	# Check if Dir is git directory
	if (((Get-ChildItem -Force $Global:GlobalPath).Name).Contains(".git")) {
		# Git pull
		git pull
		createMessagebox "Erfolgreich" ( git pull | Out-String) " "
	} else {
		# Dir ist kein git dir
		createMessagebox "Fehler" "Sie müssen ein git repository angeben" "Angegebener Pfad ist kein Git Repository"
	}
}

# push project
$btn_push_clicked=
{
	# Update path
	updatePath

	# Check if Dir is git directory 
	if (((Get-ChildItem -Force $Global:GlobalPath).Name).Contains(".git")) {
		# Needed because of git Command
		$CurrentBranch = git rev-parse --abbrev-ref HEAD

		# Push the git dir
		git push --set-upstream origin $CurrentBranch
		createMessagebox "Erfolgreich" ( git push --set-upstream origin $CurrentBranch | Out-String) " "
	} else {
		# Dir ist kein git dir
		createMessagebox "Fehler" "Sie müssen ein git repository angeben" "Angegebener Pfad ist kein Git Repository"
	}
}


#_______________________________________________________________


# add all new files to Git Project
$btn_git_add_clicked= 
{
	# Update Path
	updatePath

	# Check if Dir is git directory
	if (((Get-ChildItem -Force $Global:GlobalPath).Name).Contains(".git")) {
		# Add all files
		git add *

		# Refresh the Staus Listbox
		ControlListboxDisplay("Status")
		createMessagebox "Erfolg" "Alle ihre veränderungen wurde übernommen" (git add * | Out-String)
	} else {
		# Dir ist kein git dir
		createMessagebox "Fehler" "Sie müssen ein git repository angeben" "Angegebener Pfad ist kein Git Repository"
	}

	
}

# When project starts
$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$GitHub_GUI.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#region Generated Form Code (SHOULD NOT TOUCH!!!!)
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 412
$System_Drawing_Size.Width = 982
$GitHub_GUI.ClientSize = $System_Drawing_Size
$GitHub_GUI.DataBindings.DefaultDataSourceUpdateMode = 0
$GitHub_GUI.FormBorderStyle = 1
$GitHub_GUI.Name = "GitHub_GUI"
$GitHub_GUI.Text = "GitHub GUI"


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
$btn_open_project.TabIndex = 22
$btn_open_project.Text = "Open Project"
$btn_open_project.UseVisualStyleBackColor = $True
$btn_open_project.add_Click($btn_open_project_clicked)

$GitHub_GUI.Controls.Add($btn_open_project)


$btn_new_project.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 143
$System_Drawing_Point.Y = 73
$btn_new_project.Location = $System_Drawing_Point
$btn_new_project.Name = "btn_new_project"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 39
$System_Drawing_Size.Width = 96
$btn_new_project.Size = $System_Drawing_Size
$btn_new_project.TabIndex = 21
$btn_new_project.Text = "Clone Project"
$btn_new_project.UseVisualStyleBackColor = $True
$btn_new_project.add_Click($btn_new_project_clicked)

$GitHub_GUI.Controls.Add($btn_new_project)


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
$btn_remove_file.TabIndex = 20
$btn_remove_file.Text = "Delete"
$btn_remove_file.UseVisualStyleBackColor = $True
$btn_remove_file.add_Click($btn_remove_file_clicked)

$GitHub_GUI.Controls.Add($btn_remove_file)


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
$btn_open_file.TabIndex = 19
$btn_open_file.Text = "Open"
$btn_open_file.UseVisualStyleBackColor = $True
$btn_open_file.add_Click($btn_open_file_clicked)

$GitHub_GUI.Controls.Add($btn_open_file)


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
$btn_git_add.TabIndex = 18
$btn_git_add.Text = "Git Add"
$btn_git_add.UseVisualStyleBackColor = $True
$btn_git_add.add_Click($btn_git_add_clicked)

$GitHub_GUI.Controls.Add($btn_git_add)


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
$btn_git_initialise.TabIndex = 17
$btn_git_initialise.Text = "Initialise Git here"
$btn_git_initialise.UseVisualStyleBackColor = $True
$btn_git_initialise.add_Click($btn_git_initialise_clicked)

$GitHub_GUI.Controls.Add($btn_git_initialise)


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
$btn_show_files.TabIndex = 16
$btn_show_files.Text = "Show Files"
$btn_show_files.UseVisualStyleBackColor = $True
$btn_show_files.add_Click($btn_show_files_clicked)

$GitHub_GUI.Controls.Add($btn_show_files)


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
$btn_show_history.TabIndex = 15
$btn_show_history.Text = "History"
$btn_show_history.UseVisualStyleBackColor = $True
$btn_show_history.add_Click($btn_show_history_clicked)

$GitHub_GUI.Controls.Add($btn_show_history)


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
$btn_show_status.TabIndex = 14
$btn_show_status.Text = "Status"
$btn_show_status.UseVisualStyleBackColor = $True
$btn_show_status.add_Click($btn_show_status_clicked)

$GitHub_GUI.Controls.Add($btn_show_status)

$listbox_display_infos.DataBindings.DefaultDataSourceUpdateMode = 0
$listbox_display_infos.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 556
$System_Drawing_Point.Y = 151
$listbox_display_infos.Location = $System_Drawing_Point
$listbox_display_infos.Name = "listbox_display_infos"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 225
$System_Drawing_Size.Width = 292
$listbox_display_infos.Size = $System_Drawing_Size
$listbox_display_infos.TabIndex = 23

$GitHub_GUI.Controls.Add($listbox_display_infos)

$label_commit_description.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 130
$System_Drawing_Point.Y = 189
$label_commit_description.Location = $System_Drawing_Point
$label_commit_description.Name = "label_commit_description"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 13
$System_Drawing_Size.Width = 157
$label_commit_description.Size = $System_Drawing_Size
$label_commit_description.TabIndex = 12
$label_commit_description.Text = "Description:"

$GitHub_GUI.Controls.Add($label_commit_description)


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
$btn_pull.TabIndex = 11
$btn_pull.Text = "Pull Project"
$btn_pull.UseVisualStyleBackColor = $True
$btn_pull.add_Click($btn_pull_clicked)

$GitHub_GUI.Controls.Add($btn_pull)

$txtbox_commit_description.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 130
$System_Drawing_Point.Y = 205
$txtbox_commit_description.Location = $System_Drawing_Point
$txtbox_commit_description.Name = "txtbox_commit_description"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 204
$txtbox_commit_description.Size = $System_Drawing_Size
$txtbox_commit_description.TabIndex = 10

$GitHub_GUI.Controls.Add($txtbox_commit_description)


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
$btn_push.TabIndex = 9
$btn_push.Text = "Push Project"
$btn_push.UseVisualStyleBackColor = $True
$btn_push.add_Click($btn_push_clicked)

$GitHub_GUI.Controls.Add($btn_push)


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
$btn_commit.TabIndex = 8
$btn_commit.Text = "Commit"
$btn_commit.UseVisualStyleBackColor = $True
$btn_commit.add_Click($btn_commit_clicked)

$GitHub_GUI.Controls.Add($btn_commit)


$btn_open_select_branch.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 443
$System_Drawing_Point.Y = 117
$btn_open_select_branch.Location = $System_Drawing_Point
$btn_open_select_branch.Name = "btn_open_select_branch"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 85
$btn_open_select_branch.Size = $System_Drawing_Size
$btn_open_select_branch.TabIndex = 7
$btn_open_select_branch.Text = "Select Branch"
$btn_open_select_branch.UseVisualStyleBackColor = $True
$btn_open_select_branch.add_Click($btn_open_select_branch_clicked)

$GitHub_GUI.Controls.Add($btn_open_select_branch)

$txtbox_branch.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 393
$System_Drawing_Point.Y = 154
$txtbox_branch.Location = $System_Drawing_Point
$txtbox_branch.Name = "txtbox_branch"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 135
$txtbox_branch.Size = $System_Drawing_Size
$txtbox_branch.TabIndex = 6

$GitHub_GUI.Controls.Add($txtbox_branch)

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
$label_branch.TabIndex = 5
$label_branch.Text = "Branch"

$GitHub_GUI.Controls.Add($label_branch)

$txtbox_repository.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 218
$System_Drawing_Point.Y = 154
$txtbox_repository.Location = $System_Drawing_Point
$txtbox_repository.Name = "txtbox_repository"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 154
$txtbox_repository.Size = $System_Drawing_Size
$txtbox_repository.TabIndex = 4

$GitHub_GUI.Controls.Add($txtbox_repository)

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
$label_repository.TabIndex = 3
$label_repository.Text = "Repository"

$GitHub_GUI.Controls.Add($label_repository)

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
$label_path.TabIndex = 2
$label_path.Text = "Path:"

$GitHub_GUI.Controls.Add($label_path)

$txtbox_projectPath.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 21
$System_Drawing_Point.Y = 154
$txtbox_projectPath.Location = $System_Drawing_Point
$txtbox_projectPath.Name = "txtbox_path"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 184
$txtbox_projectPath.Size = $System_Drawing_Size
$txtbox_projectPath.TabIndex = 1

$GitHub_GUI.Controls.Add($txtbox_projectPath)

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
$label_title.TabIndex = 0
$label_title.Text = "GitHub GUI"

$GitHub_GUI.Controls.Add($label_title)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $GitHub_GUI.WindowState
#Init the OnLoad event to correct the initial state of the form
$GitHub_GUI.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$GitHub_GUI.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm

# Reset Global Path after programm ran
$Global:GlobalPath = $null
Set-Location "$env:HOMEDRIVE\$env:HOMEPATH"
