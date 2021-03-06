<#

    SCRIPT : BirthdaysHistory.ps1
    
    DESCRIPTION : Ce script permet de lister tous les anniversaires d'une personne
                  sur une période donnée.
                  
    AUTEUR : Johann BARON
    
    VERSIONS :
    - 28/01/2021, v1.0
    
#>


#region CHARGEMENT DES ASSEMBLY

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[System.Windows.Forms.Application]::EnableVisualStyles()

#endregion


#region CREATION DES FONCTIONS

# ================================
# Fonction pour masquer la console
# ================================

# Link : https://stackoverflow.com/questions/40617800/opening-powershell-script-and-hide-command-prompt-but-not-the-gui


Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

Function Hide-Console {

    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}

Hide-Console


# ======================================
# Fonction pour lister les anniversaires
# ======================================

Function Get-Birthdays {
    
    $nbMonday = 0
    $nbTuesday = 0
    $nbWednesday = 0
    $nbThursday = 0
    $nbFriday = 0
    $nbSaturday = 0
    $nbSunday = 0
        
    $birthdaysListView.Items.Clear()
    $daysListView.Items.Clear()
    
    $limitYear = ''
    
    if($inputYearMaskedTextBox.Enabled){
        $limitYear = $inputYearMaskedTextBox.Text
    } else {
        $limitYear = $currentYearRadioButton.Text
    }
    
    $years = ($yearComboBox.SelectedItem)..$limitYear
    
    foreach ($year in $years) {
        
        $birthdaysListViewItem = New-Object System.Windows.Forms.ListViewItem
        
        $age = $year - ($yearComboBox.SelectedItem)
            if ($age -eq 0) {
                
                $birthdaysListViewItem.Text = "Naissance"
                
            } elseif ($age -eq 1) {
                
                $birthdaysListViewItem.Text = "$age an"
                
            } else {
                
                $birthdaysListViewItem.Text = "$age ans"
                
            }
                                
        $dateTemp = Get-Date "$($dayComboBox.SelectedItem)/$($monthComboBox.SelectedItem)/$($year)"
                
        $birthdaysListViewItem.SubItems.Add($((Get-Culture).TextInfo.ToTitleCase(($dateTemp.ToLongDateString()))))
        $birthdaysListViewItem.SubItems.Add($year)
        $birthdaysListView.Items.AddRange($birthdaysListViewItem)
        
        switch ($dateTemp.DayOfWeek){
            "Monday" { $nbMonday++ }
            "Tuesday" { $nbTuesday++ }
            "Wednesday" { $nbWednesday++ }
            "Thursday" { $nbThursday++ }
            "Friday" { $nbFriday++ }
            "Saturday" { $nbSaturday++ }
            "Sunday" { $nbSunday++ }
            default { continue }
        }
    }
    
    $daysOfWeek = ("Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche")
        
    foreach ($day in $daysOfWeek){
            
        $daysListViewItem = New-Object System.Windows.Forms.ListViewItem
        $daysListViewItem.Text = $day
        
        switch ($day){
            "Lundi" { $daysListViewItem.SubItems.Add($nbMonday) }
            "Mardi" { $daysListViewItem.SubItems.Add($nbTuesday) }
            "Mercredi" { $daysListViewItem.SubItems.Add($nbWednesday) }
            "Jeudi" { $daysListViewItem.SubItems.Add($nbThursday) }
            "Vendredi" { $daysListViewItem.SubItems.Add($nbFriday) }
            "Samedi" { $daysListViewItem.SubItems.Add($nbSaturday) }
            "Dimanche" { $daysListViewItem.SubItems.Add($nbSunday) }
            default { Write-Host "Erreur de jour !" -ForegroundColor Red }
        }
            
        $daysListView.Items.AddRange($daysListViewItem)
    }
}

#endregion


#region CREATION DES FORMES

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.StartPosition = 'CenterScreen'
$mainForm.Size = '870,500'
$mainForm.Text = "Historique des anniversaires"
$mainForm.Margin = "0,0,0,0"
$mainForm.MinimumSize = '870,500'


$mainTableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
$mainTableLayoutPanel.Dock = 'Fill'
$mainTableLayoutPanel.BackColor = '240,240,255,240'
$mainTableLayoutPanel.CellBorderStyle = 'None'
$mainTableLayoutPanel.ColumnCount = 1
$mainTableLayoutPanel.RowCount = 5
[void]$mainTableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 10)))
[void]$mainTableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 15)))
[void]$mainTableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 10)))
[void]$mainTableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 55)))
[void]$mainTableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 10)))


$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Historique des anniversaires"
$titleLabel.TextAlign = 'MiddleCenter'
$titleLabel.Dock = 'Fill'
$titleLabel.Margin = '0,0,0,0'
$titleLabel.Font = 'Segoe UI, 14pt, style=Bold'
$titleLabel.BackColor = 'DodgerBlue'


$configTableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
$configTableLayoutPanel.Dock = 'Fill'
$configTableLayoutPanel.ColumnCount = 2
$configTableLayoutPanel.RowCount = 2
[void]$configTableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 40)))
[void]$configTableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 60)))
[void]$configTableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
[void]$configTableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
$configTableLayoutPanel.Margin = '0,0,0,0'


$dateOfBirthLabel = New-Object System.Windows.Forms.Label
$dateOfBirthLabel.Text = "Date de naissance :"
$dateOfBirthLabel.TextAlign = 'MiddleLeft'
$dateOfBirthLabel.AutoSize = $true
$dateOfBirthLabel.Dock = 'Bottom'
$dateOfBirthLabel.Font = 'Arial, 10pt'
 
 
$limitDateLabel = New-Object System.Windows.Forms.Label
$limitDateLabel.Text = "Historique jusqu'à l'année :"
$limitDateLabel.TextAlign = 'MiddleLeft'
$limitDateLabel.AutoSize = $true
$limitDateLabel.Dock = 'Bottom'
$limitDateLabel.Font = 'Segoe UI, 10pt'

  
$dateOfBirthFlowLayoutPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$dateOfBirthFlowLayoutPanel.AutoSize = $true
$dateOfBirthFlowLayoutPanel.AutoSizeMode = 'GrowAndShrink'
$dateOfBirthFlowLayoutPanel.Dock = 'Fill'
$dateOfBirthFlowLayoutPanel.FlowDirection = 'LeftToRight'
$dateOfBirthFlowLayoutPanel.WrapContents = $true


$dayComboBox = New-Object System.Windows.Forms.ComboBox
$dayComboBox.Text = "--JJ--"
$dayComboBox.Items.AddRange(1..31)
$dayComboBox.AutoSize = $true
$dayComboBox.AutoCompleteMode = 'SuggestAppend'
$dayComboBox.AutoCompleteSource = 'ListItems'


$monthComboBox = New-Object System.Windows.Forms.ComboBox
$monthComboBox.Text = "--MM--"
$monthComboBox.Items.AddRange(1..12)


$yearComboBox = New-Object System.Windows.Forms.ComboBox
$yearComboBox.Text = "--AAAA--"
$yearComboBox.Items.AddRange(((Get-Date).Year - 100)..((Get-Date).Year))


$dateOfBirthFlowLayoutPanel.Controls.Add($dayComboBox)
$dateOfBirthFlowLayoutPanel.Controls.Add($monthComboBox)
$dateOfBirthFlowLayoutPanel.Controls.Add($yearComboBox)


$limitDateFlowLayoutPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$limitDateFlowLayoutPanel.AutoSize = $true
$limitDateFlowLayoutPanel.AutoSizeMode = 'GrowAndShrink'
$limitDateFlowLayoutPanel.Dock = 'Fill'
$limitDateFlowLayoutPanel.FlowDirection = 'LeftToRight'
$limitDateFlowLayoutPanel.WrapContents = $true


$currentYearRadioButton = New-Object System.Windows.Forms.RadioButton
$currentYearRadioButton.Text = "$((Get-Date).Year)"
$currentYearRadioButton.Checked = $true
$currentYearRadioButton.Add_Click({
    $inputYearMaskedTextBox.Enabled = $false
})


$otherYearRadioButton = New-Object System.Windows.Forms.RadioButton
$otherYearRadioButton.Text = "Autre :"
$otherYearRadioButton.Add_Click({
    $inputYearMaskedTextBox.Enabled = $true
})


$inputYearMaskedTextBox = New-Object System.Windows.Forms.MaskedTextBox
$inputYearMaskedTextBox.Enabled = $false
$inputYearMaskedTextBox.PromptChar = 'A'
$inputYearMaskedTextBox.AsciiOnly = $true
$inputYearMaskedTextBox.Mask = '0000'


$limitDateFlowLayoutPanel.Controls.Add($currentYearRadioButton)
$limitDateFlowLayoutPanel.Controls.Add($otherYearRadioButton)
$limitDateFlowLayoutPanel.Controls.Add($inputYearMaskedTextBox)


$configTableLayoutPanel.Controls.Add($dateOfBirthLabel)
$configTableLayoutPanel.Controls.Add($limitDateLabel)
$configTableLayoutPanel.Controls.Add($dateOfBirthFlowLayoutPanel)
$configTableLayoutPanel.Controls.Add($limitDateFlowLayoutPanel)


$validateButton = New-Object System.Windows.Forms.Button
$validateButton.Text = "Valider"
$validateButton.TextAlign = 'MiddleCenter'
$validateButton.AutoSize = $true
$validateButton.Top = (($mainTableLayoutPanel.Height * 0.1) - $validateButton.Height) / 2
$validateButton.Left = (($mainTableLayoutPanel.Width - $validateButton.Width) / 2)
$validateButton.Anchor = 'None'
$validateButton.Add_Click({
    Get-Birthdays
})


$resultTableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
$resultTableLayoutPanel.Dock = 'Fill'
$resultTableLayoutPanel.ColumnCount = 2
$resultTableLayoutPanel.RowCount = 2
[void]$resultTableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 15)))
[void]$resultTableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 85)))
[void]$resultTableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
[void]$resultTableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
$resultTableLayoutPanel.BackColor = 'DeepSkyBlue'
$resultTableLayoutPanel.Margin = '0,0,0,0'


$birthdaysLabel = New-Object System.Windows.Forms.Label
$birthdaysLabel.Text = "Historique :"
$birthdaysLabel.TextAlign = 'MiddleCenter'
$birthdaysLabel.AutoSize = $true
$birthdaysLabel.Dock = 'Bottom'
$birthdaysLabel.Font = 'Verdana, 10pt'


$daysLabel = New-Object System.Windows.Forms.Label
$daysLabel.Text = "Répartition des anniversaires par jours :"
$daysLabel.TextAlign = 'MiddleCenter'
$daysLabel.AutoSize = $true
$daysLabel.Dock = 'Bottom'
$daysLabel.Font = "Tahoma, 10pt"


$birthdaysListView = New-Object System.Windows.Forms.ListView
$birthdaysListView.Dock = 'Fill'
$birthdaysListView.View = 'Details'
[void]$birthdaysListView.Columns.Add("Âge")
[void]$birthdaysListView.Columns.Add("Date d'anniversaire")
[void]$birthdaysListView.Columns.Add("Année")


$daysListView = New-Object System.Windows.Forms.ListView
$daysListView.Dock = 'Fill'
$daysListView.View = 'Details'
[void]$daysListView.Columns.Add("Jour")
[void]$daysListView.Columns.Add("Nombre d'anniversaires")


$resultTableLayoutPanel.Controls.Add($birthdaysLabel)
$resultTableLayoutPanel.Controls.Add($daysLabel)
$resultTableLayoutPanel.Controls.Add($birthdaysListView)
$resultTableLayoutPanel.Controls.Add($daysListView)


$quitButton = New-Object System.Windows.Forms.Button
$quitButton.Text = "Quitter"
$quitButton.TextAlign = 'MiddleCenter'
$quitButton.AutoSize = $true
$quitButton.Top = (($mainTableLayoutPanel.Height * 0.1) - $quitButton.Height) / 2
$quitButton.Left = ($mainTableLayoutPanel.Width - $validateButton.Width) / 2
$quitButton.Anchor = 'None'
$quitButton.Add_Click({
    $mainForm.Close()
})


$mainTableLayoutPanel.Controls.Add($titleLabel)
$mainTableLayoutPanel.Controls.Add($configTableLayoutPanel)
$mainTableLayoutPanel.Controls.Add($validateButton)
$mainTableLayoutPanel.Controls.Add($resultTableLayoutPanel)
$mainTableLayoutPanel.Controls.Add($quitButton)


$mainForm.Controls.Add($mainTableLayoutPanel)


$mainForm.ShowDialog()
