#Generated Form Function
function GenerateForm {
########################################################################
# Code Generated By: SAPIEN Technologies PrimalForms (Community Edition) v1.0.10.0
# Generated On: 26.10.2021 09:51
# Generated By: sorus
########################################################################

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion

#region Generated Form Objects
$branch_manager = New-Object System.Windows.Forms.Form
$btn_switch_branch = New-Object System.Windows.Forms.Button
$txtbox_new_branch_name = New-Object System.Windows.Forms.TextBox
$btn_new_branch = New-Object System.Windows.Forms.Button
$btn_delete_branch = New-Object System.Windows.Forms.Button
$btn_refresh = New-Object System.Windows.Forms.Button
$btn_version_ctrl = New-Object System.Windows.Forms.Button
$listbox_show_branches = New-Object System.Windows.Forms.ListBox
$label_branches_title = New-Object System.Windows.Forms.Label
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

Set-Location $txtbox_path.Text

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
#Provide Custom Code for events specified in PrimalForms.
$btn_new_branch_clicked= 
{
	git checkout -b $txtbox_new_branch_name.Text
	git push --set-upstream origin $txtbox_new_branch_name.Text
	$txtbox_new_branch_name.Clear()
	$listbox_show_branches.Items.Clear()
	$branch_list = git branch -a
	$listbox_show_branches.Items.AddRange($branch_list)
}

$btn_delete_branch_clicked= 
{
	$branch = $listbox_show_branches.SelectedItem
	git branch -d $branch.trim()
	git push origin -d $branch.trim()
	$listbox_show_branches.Items.Clear()
	$branch_list = git branch -a
	$listbox_show_branches.Items.AddRange($branch_list)
}

$btn_switch_branch_clicked= 
{
	$branch_box = $txtbox_new_branch_name.Text
		if ( '' -ne $txtbox_new_branch_name.Text) {
			$branch_box = $txtbox_new_branch_name.Text
			git checkout $branch_box	
			$txtbox_new_branch_name.Clear()
		} elseif ($branch_slct -ne $global:txtbox_branch.Text -and $null -ne $listbox_show_branches.SelectedItem ) {
			$branch_slct = $listbox_show_branches.SelectedItem.trim()
			$branch_slct = $branch_slct.Split(" ")[0]
			git checkout $branch_slct
		}
	$branch_list = git branch -a
	
	$listbox_show_branches.Items.Clear()
	$listbox_show_branches.Items.AddRange($branch_list)
	$global:txtbox_branch.Text = git rev-parse --abbrev-ref HEAD 	
}

$btn_version_ctrl_clicked=
{
	$commit_list = git log --oneline
	$listbox_show_branches.Items.Clear()
	$listbox_show_branches.Items.AddRange($commit_list)
}

$btn_refresh_clicked=
{
	$branch_list = git branch -a
	$listbox_show_branches.Items.Clear()
	$listbox_show_branches.Items.AddRange($branch_list)
}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$branch_manager.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 366
$System_Drawing_Size.Width = 323
$branch_manager.ClientSize = $System_Drawing_Size
$branch_manager.DataBindings.DefaultDataSourceUpdateMode = 0
$branch_manager.FormBorderStyle = 1
$branch_manager.Name = "branch_manager"
$System_Windows_Forms_Padding = New-Object System.Windows.Forms.Padding
$System_Windows_Forms_Padding.All = 15
$System_Windows_Forms_Padding.Bottom = 15
$System_Windows_Forms_Padding.Left = 15
$System_Windows_Forms_Padding.Right = 15
$System_Windows_Forms_Padding.Top = 15
$branch_manager.Padding = $System_Windows_Forms_Padding
$branch_manager.Text = "Branch Manager"


$btn_switch_branch.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 20
$System_Drawing_Point.Y = 295
$btn_switch_branch.Location = $System_Drawing_Point
$btn_switch_branch.Name = "btn_switch_branch"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 30
$System_Drawing_Size.Width = 97
$btn_switch_branch.Size = $System_Drawing_Size
$btn_switch_branch.TabIndex = 5
$btn_switch_branch.Text = "Switch"
$btn_switch_branch.UseVisualStyleBackColor = $True
$btn_switch_branch.add_Click($btn_switch_branch_clicked)

$branch_manager.Controls.Add($btn_switch_branch)

$btn_version_ctrl.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 20
$System_Drawing_Point.Y = 330
$btn_version_ctrl.Location = $System_Drawing_Point
$btn_version_ctrl.Name = "btn_version_control"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 30
$System_Drawing_Size.Width = 205
$btn_version_ctrl.Size = $System_Drawing_Size
$btn_version_ctrl.TabIndex = 5
$btn_version_ctrl.Text = "Version Control"
$btn_version_ctrl.UseVisualStyleBackColor = $True
$btn_version_ctrl.add_Click($btn_version_ctrl_clicked)

$branch_manager.Controls.Add($btn_version_ctrl)

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

$branch_manager.Controls.Add($txtbox_new_branch_name)


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

$branch_manager.Controls.Add($btn_new_branch)


$btn_delete_branch.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 123
$System_Drawing_Point.Y = 295
$btn_delete_branch.Location = $System_Drawing_Point
$btn_delete_branch.Name = "btn_delete_branch"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 30
$System_Drawing_Size.Width = 102
$btn_delete_branch.Size = $System_Drawing_Size
$btn_delete_branch.TabIndex = 2
$btn_delete_branch.Text = "Delete"
$btn_delete_branch.UseVisualStyleBackColor = $True
$btn_delete_branch.add_Click($btn_delete_branch_clicked)

$branch_manager.Controls.Add($btn_delete_branch)

$btn_refresh.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 230
$System_Drawing_Point.Y = 330
$btn_refresh.Location = $System_Drawing_Point
$btn_refresh.Name = "btn_refresh"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 30
$System_Drawing_Size.Width = 80
$btn_refresh.Size = $System_Drawing_Size
$btn_refresh.TabIndex = 2
$btn_refresh.Text = "Refresh"
$btn_refresh.UseVisualStyleBackColor = $True
$btn_refresh.add_Click($btn_refresh_clicked)

$branch_manager.Controls.Add($btn_refresh)

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
$branch_list = git branch -a
$listbox_show_branches.Items.AddRange($branch_list)


$branch_manager.Controls.Add($listbox_show_branches)

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

$branch_manager.Controls.Add($label_branches_title)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $branch_manager.WindowState
#Init the OnLoad event to correct the initial state of the form
$branch_manager.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$branch_manager.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm
