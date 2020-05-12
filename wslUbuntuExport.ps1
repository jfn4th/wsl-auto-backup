Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
[bool] $notReady = $true
while ($notReady) {
    $msgBoxInput =  [System.Windows.MessageBox]::Show('Ready to shutdown and export Ubuntu?','WSL Ubuntu Export','YesNoCancel','Error')
    switch ($msgBoxInput) {
        'Yes' {
            $notReady = $false;
        }
        'No' {
            $delayMinutes = 0
            $form = New-Object System.Windows.Forms.Form
            $form.Text = 'Export Delay'
            $form.Size = New-Object System.Drawing.Size(300,200)
            $form.StartPosition = 'CenterScreen'
            $okButton = New-Object System.Windows.Forms.Button
            $okButton.Location = New-Object System.Drawing.Point(75,120)
            $okButton.Size = New-Object System.Drawing.Size(75,23)
            $okButton.Text = 'OK'
            $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $form.AcceptButton = $OKButton
            $form.Controls.Add($OKButton)
            $cancelButton = New-Object System.Windows.Forms.Button
            $cancelButton.Location = New-Object System.Drawing.Point(150,120)
            $cancelButton.Size = New-Object System.Drawing.Size(75,23)
            $cancelButton.Text = 'Cancel'
            $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
            $form.CancelButton = $cancelButton
            $form.Controls.Add($cancelButton)
            $label = New-Object System.Windows.Forms.Label
            $label.Location = New-Object System.Drawing.Point(10,20)
            $label.Size = New-Object System.Drawing.Size(280,20)
            $label.Text = 'Delay for minutes:'
            $form.Controls.Add($label)
            $textBox = New-Object System.Windows.Forms.TextBox
            $textBox.Location = New-Object System.Drawing.Point(10,40)
            $textBox.Size = New-Object System.Drawing.Size(260,20)
            $textBox.Add_TextChanged({
                if ($this.Text -match '[^0-9]') {
                    $cursorPos = $this.SelectionStart
                    $this.Text = $this.Text -replace '[^a-z 0-9]',''
                    # move the cursor to the end of the text:
                    # $this.SelectionStart = $this.Text.Length

                    # or leave the cursor where it was before the replace
                    $this.SelectionStart = $cursorPos - 1
                    $this.SelectionLength = 0
                    }
                })
            $form.Controls.Add($textBox)
            $form.Topmost = $true
            $form.Add_Shown({$textBox.Select()})
            $result = $form.ShowDialog()
            if ($result -eq [System.Windows.Forms.DialogResult]::OK)
            {
                $x = $textBox.Text

                $delayMinutes = $x.ToInt32($null) * 60
                Start-Sleep -s $delayMinutes
            }
        }
        'Cancel' {
            exit
        }
    }
}

wsl --shutdown
cd D:\Backup\Ubuntu
Start-Sleep -s 2
wsl --export Ubuntu "$(get-date -f yyyy-MM-dd-HHmm).tar"
[System.Windows.MessageBox]::Show('Export Complete!')