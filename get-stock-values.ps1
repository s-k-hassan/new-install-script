
$tick_list=@("WOW.AX","DDR.AX","QAN.AX")
$API_key=get-content -raw ./key.txt
foreach($tickerID in $tick_list){
$stock_api_url=("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol="+$tickerID+"&interval=1min&apikey="+$API_key+"&datatype=csv")
$download_folder="/home/splunk/alphavantagedl/"
$export_folder="/home/splunk/aplhavantagemon/"
$date=Get-Date -Format dd-MM-yyyy-HH_mm
$csv_transform_file=$download_folder+"csv_results"+$date+".csv"
Invoke-RestMethod -Method Get $stock_api_url | Out-File -FilePath $csv_transform_file
Import-Csv $csv_transform_file | Select-Object *,@{Name="ticker";Expression={$tickerID}} | Export-Csv $export_folder$tickerID$date".csv" -NoTypeInformation
}
