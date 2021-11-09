#Generated Form Function
function GenerateForm {
########################################################################
# Project Name: Git Gui
# Design by: Daniel Greil, Sorusch Afkhami
# Code by: Daniel Greil
########################################################################

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion

#region Generated Form Objects
# Form
$Select_Branch_Form = New-Object System.Windows.Forms.Form

# Buttons
$btn_delete_branch = New-Object System.Windows.Forms.Button
$btn_new_branch = New-Object System.Windows.Forms.Button
$btn_select_banch = New-Object System.Windows.Forms.Button

# Listboxes
$listbox_show_branches = New-Object System.Windows.Forms.ListBox

# Labels
$label_branches_title = New-Object System.Windows.Forms.Label

# Textboxes
$txtbox_new_branch_name = New-Object System.Windows.Forms.TextBox

$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects


#-------------------------------------------------------------
# UpdateBranchListbox
#
# Description: 
# Updating The Brach Listbox 
#
#-------------------------------------------------------------
function UpdateBranchListbox {
	$listbox_show_branches.Items.Clear()
	foreach($item in git branch) {
		$listbox_show_branches.Items.Add($item.Trim(" "))
	}
}


# Below description of what should happen

# Add new Branch
$btn_new_branch_clicked= 
{
	$NewBranchName = $txtbox_new_branch_name.Text
	$NewBranchName = $NewBranchName.Replace(" ", "")
	if ($NewBranchName -eq "") {
		createMessagebox "Fehler" "Kein Name angegeben" "Es scheint, dass Sie den Namen von den neuen Branch nicht angegeben haben."
	} else {
		# Check if branch has already been created
		# Var True if Name already Exists
		$NameExistent = $false

		# Scan Listbox for already existant Item
		foreach ($Branchname in $listbox_show_branches.Items) {
			if ($Branchname -eq $NewBranchName) {
				$NameExistent = $true
			}
		}

		# Check if Name already exists
		if ($NameExistent -eq $true) {
			Global:createMessagebox "Fehler" "Branch bereits Vorhanden" "Sie haben einen Doppelten Branch engegeben"
			$NewBranchName = ""
		} else {
			git branch $NewBranchName
		}
	}

	# Clear Txtbox
	$txtbox_new_branch_name.Text = ""

	# Update Listbox
	UpdateBranchListbox
}


#_______________________________________________________________


# Delete selected Branch
$btn_delete_branch_clicked=
{
	# Check if item has been Selected
	if ($listbox_show_branches.SelectedIndex -eq -1) {
		Global:createMessagebox "Fehler" "Es wurde kein branch gewählt" "Sie haben keinen branch zum löschen ausgewählt"
	} else {
		git branch -d $listbox_show_branches.SelectedItem.Trim()
	}

	# Update Listbox
	UpdateBranchListbox
}

# Close Form and return branch
$btn_select_banch_clicked=
{
	$BranchName = $listbox_show_branches.SelectedItem
	$BranchName = $BranchName.Trim(" ")
	if ($listbox_show_branches.SelectedIndex -eq -1) {
		Global:createMessagebox "Fehler" "Es wurde kein branch ausgewählt" "Sie haben keinen branch zum auswählen gewählt"
	} else {
		git checkout $BranchName
	}

	# Start Closing the Programm
	Start-Sleep -Seconds 1
	$Select_Branch_Form.Close()
}


#_______________________________________________________________


$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$Select_Branch_Form.WindowState = $InitialFormWindowState
	Set-Location $Global:GlobalPath

	UpdateBranchListbox
}

#----------------------------------------------
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 366
$System_Drawing_Size.Width = 323
$Select_Branch_Form.ClientSize = $System_Drawing_Size
$Select_Branch_Form.DataBindings.DefaultDataSourceUpdateMode = 0
$Select_Branch_Form.FormBorderStyle = 1
$Select_Branch_Form.Name = "select_branch"
$System_Windows_Forms_Padding = New-Object System.Windows.Forms.Padding
$System_Windows_Forms_Padding.All = 15
$System_Windows_Forms_Padding.Bottom = 15
$System_Windows_Forms_Padding.Left = 15
$System_Windows_Forms_Padding.Right = 15
$System_Windows_Forms_Padding.Top = 15
$Select_Branch_Form.Padding = $System_Windows_Forms_Padding
$Select_Branch_Form.Text = "Select a Branch"


$btn_delete_branch.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 20
$System_Drawing_Point.Y = 295
$btn_delete_branch.Location = $System_Drawing_Point
$btn_delete_branch.Name = "btn_delete_branch"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 30
$System_Drawing_Size.Width = 97
$btn_delete_branch.Size = $System_Drawing_Size
$btn_delete_branch.TabIndex = 5
$btn_delete_branch.Text = "Delete"
$btn_delete_branch.UseVisualStyleBackColor = $True
$btn_delete_branch.add_Click($btn_delete_branch_clicked)

$Select_Branch_Form.Controls.Add($btn_delete_branch)

$txtbox_new_branch_name.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 108
$System_Drawing_Point.Y = 70
$txtbox_new_branch_name.Location = $System_Drawing_Point
$txtbox_new_branch_name.Name = "txtbox_new_branch_name"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 197
$txtbox_new_branch_name.Size = $System_Drawing_Size
$txtbox_new_branch_name.TabIndex = 4

$Select_Branch_Form.Controls.Add($txtbox_new_branch_name)


$btn_new_branch.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 20
$System_Drawing_Point.Y = 70
$btn_new_branch.Location = $System_Drawing_Point
$btn_new_branch.Name = "btn_new_branch"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 22
$System_Drawing_Size.Width = 74
$btn_new_branch.Size = $System_Drawing_Size
$btn_new_branch.TabIndex = 3
$btn_new_branch.Text = "New Branch"
$btn_new_branch.UseVisualStyleBackColor = $True
$btn_new_branch.add_Click($btn_new_branch_clicked)

$Select_Branch_Form.Controls.Add($btn_new_branch)


$btn_select_banch.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 123
$System_Drawing_Point.Y = 295
$btn_select_banch.Location = $System_Drawing_Point
$btn_select_banch.Name = "btn_select_banch"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 30
$System_Drawing_Size.Width = 105
$btn_select_banch.Size = $System_Drawing_Size
$btn_select_banch.TabIndex = 2
$btn_select_banch.Text = "Select"
$btn_select_banch.UseVisualStyleBackColor = $True
$btn_select_banch.add_Click($btn_select_banch_clicked)

$Select_Branch_Form.Controls.Add($btn_select_banch)

$listbox_show_branches.DataBindings.DefaultDataSourceUpdateMode = 0
$listbox_show_branches.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 20
$System_Drawing_Point.Y = 106
$listbox_show_branches.Location = $System_Drawing_Point
$listbox_show_branches.Name = "listbox_show_branches"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 173
$System_Drawing_Size.Width = 285
$listbox_show_branches.Size = $System_Drawing_Size
$listbox_show_branches.TabIndex = 1

$Select_Branch_Form.Controls.Add($listbox_show_branches)

$label_branches_title.DataBindings.DefaultDataSourceUpdateMode = 0
$label_branches_title.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",20,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 20
$System_Drawing_Point.Y = 15
$label_branches_title.Location = $System_Drawing_Point
$label_branches_title.Name = "label_branches_title"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 53
$System_Drawing_Size.Width = 239
$label_branches_title.Size = $System_Drawing_Size
$label_branches_title.TabIndex = 0
$label_branches_title.Text = "Branches"
$label_branches_title.add_Click($handler_label1_Click)

$Select_Branch_Form.Controls.Add($label_branches_title)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $Select_Branch_Form.WindowState
#Init the OnLoad event to correct the initial state of the form
$Select_Branch_Form.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$Select_Branch_Form.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm
