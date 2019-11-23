class CallbackController < ApplicationController
	def index
		token = FetchAccountsJob.new.perform(params[:code])

		puts token
	end
end

# {"responseHeader":
# 	{"requestId":"75d83796-0e2b-11ea-9a96-00fdc19a03cf",
# 		"sendDate":"2019-11-23T20:57:31.465+01:00","isCallback":false
# 	},
# 	"access_token":"eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI2NjVjYWYwNC1jOTZjLTQ3ZDItYTczYS1mOGJiOGFkNmE5NzUiLCJpYXQiOjE1NzQ1MzkwNTEsInN1YiI6IkRvc3RlcCBkbyB1c2x1ZyBQU0QyIiwiaXNzIjoiTW9ja293ZSBBc3BzcCIsImNvbnNlbnRJZCI6IjUwODMwN2QyLTBlMmItMTFlYS05MmUyLTZmYTVjYjRmYzNlYSIsImV4cCI6MTU3NDUzOTE3MSwibmJmIjoxNTc0NTM5MDUxfQ.k2vCDCc6jO_O2bann3pft7n4L2iFIOwjSU4Jco-FQOg",
# 	"token_type":"Bearer",
# 	"expires_in":"120",
# 	"refresh_token":"eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI0YTFmYTI5Zi1jNzY2LTRmNTAtODg5Zi02YjE5YTE5YjA0NDEiLCJpYXQiOjE1NzQ1MzkwNTEsInN1YiI6IkRvc3RlcCBkbyB1c2x1ZyBQU0QyIiwiaXNzIjoiTW9ja293ZSBBc3BzcCIsImNvbnNlbnRJZCI6IjUwODMwN2QyLTBlMmItMTFlYS05MmUyLTZmYTVjYjRmYzNlYSIsImV4cCI6MTU4MTYwMDg4MSwibmJmIjoxNTc0NTM5MDUxfQ.YHm0b7ztcngl01RnF_N2VZICZbkBJeBK5l7qNYCtcbM",
# 	"scope":"ais-accounts",
# 	"scope_details":{
# 		"privilegeList":[
# 			{
# 				"ais-accounts:getAccounts":
# 				{
# 					"scopeUsageLimit":"multiple"
# 				}
# 			}
# 		],
# 		"consentId":"508307d2-0e2b-11ea-92e2-6fa5cb4fc3ea",
# 		"scopeTimeLimit":"2020-02-13T14:34:41.828+01:00",
# 		"throttlingPolicy":"psd2Regulatory"
# 	}
# }
