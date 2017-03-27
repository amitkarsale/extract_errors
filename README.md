
# Data Extraction and Clean up(ETL)

`ETL` aims to provide the analytics on frequently failing tasks from task-exports and foreman-debug logs.
It is an isolated module which works independently only on the logs provided by our customers or
end users. Logs can be foreman-debug logs or task-exports log specifically.

## Usage
It is a web portal, so no CLI available.

```
<domain_url>/                    displays all the errors occured along with their occurance date and case number.(unpolished UI)

<domain_url>/?filter=uniq        displays uniq errors along with their number of occurances with a link to message pointing to 
                                 its case number. From here one can jump to the specific case to have a detailed look on the
                                 case itself.

<domain_url>/extract_data        parse, extract and feed the data into the db. 
								 #todo make it re-run safe and provide a UI with confirmation to parse and insert data.
```

## Implementation

`ETL` maps to the datastore location of all the attachments uploaded in each an every case. 
An attachment db table is maintained with respect to the casenumber and unique UUID. 

## Fetch Records

Only those records are fetched and brought into action whose attachments are `task-export` logs, later `foreman-debug` logs would also be taken into consideration. The Extraction from the logs is done in the following step by step manner.

```ruby

@task_cases = FileAttachment.select('casenumber').where("name like '%task-export%'").limit(25)

```

### Extract Attachments

Fetched records attachments are to be extracted from the physical data store location and are stored at temporary location for parsing the log files. The attachments are placed with respect to the `case number`. The logic for attachment's location goes as follows:

```ruby
	kase_number = "001234567"
	case_split = kase_number.scan(/.{3}/) # => ["001"],["234"],["567"]

	if case_split[1].to_i  <= 600
		attachment_location = "~/cases/#{case_split[0]}/#{case_split[1]}/#{case_split[2]}/attachments/task-export*"
		#~/cases/001/234/567/attachments/task-export*

	else
		# for kase_number = "001789654"
		case_split1 = case_split[1].scan(/.{1}/); case_split2 = case_split[2].scan(/.{1}/) # => ["7"]["8"]["9"]; ["6"]["5"]["4"]
		secondary_split = case_split1 + case_split2
		path = '/'
		secondary_split.each do |i|
			path += "#{i}/"
		end
		attachment_location = "~/cases/#{case_split[0]}/#{path}/attachments/task-export*"
		# ~/cases/001/7/8/9/6/5/4/attachments/task-export*
	end

```  

### Parse Logs

Parses the log from extracted attachments. Parsing the task HTML files using nokogiri library, read all error HTML's only and
accumulates all the errors from all the `failed` and `stopped` tasks only. Gathers the occurance timestamp, the error message and respective case number.

### Insert Messages

After accumulation, a bulk insert is performed for all the errors occured for a single case with single insert statement.

```ruby
	
	def insert_messages
		cases = ["#{@case_no}"] * @error_msgs.length
		@values = @error_msgs.zip @occured_at, cases
		Error.import @columns, @values
	end

``` 


## TODO:

```
index search in availble ETL results
include foreman-debug log file in Extraction and Parsing
extraction of data to be re-run safe.
```
