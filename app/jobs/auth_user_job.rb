require 'openssl'
require "base64"
require 'simple_uuid'
require 'net/http'
require 'open3'

class AuthUserJob < ApplicationJob
  queue_as :default

  def perform
  	# path = "/Users/ritwickmalhotra/Desktop"
  	path = "/home/user16adm/Desktop"
    raw = File.read "#{path}/pwtkey.pem" 
		rsa_private = OpenSSL::PKey::RSA.new raw

		rsa_public = rsa_private.public_key
		key_id = "9badbf4941f6223c039d5bc247919b1ba911eb65"
		qseal_URL = "https://gist.githubusercontent.com/archetype2142/610a37d823a268c9c24f4e780db77220/raw/609425285b001643de47bb4131b9dba0a770f9b8/qseal.pem"
		qseal_fingerprint_url = "5ef8081658f5fc72c7268938047646cf39536ee35c14ec6b4c3005c72c940fed"
		uuid = SimpleUUID::UUID.new.to_guid
		payload = request(uuid)

		header_fields = {
			alg: "RS256",
			typ: "JWT",
			kid: key_id,
			x5u: qseal_URL,
			"x5t#S256": qseal_fingerprint_url
		}

		token = JWT.encode payload, rsa_private, 'RS256', header_fields
		json = Base64.decode64(token.split('.')[1])
		token = token.gsub(token.split('.')[1], "")


		req = "curl --request POST \\
		  --url https://api-obh.kir.pl/v2_1_1.1/auth/v2_1_1.1/authorize \\
		  --header 'Accept: application/json' \\
		  --header 'Accept-Charset: utf-8' \\
		  --header 'Content-Type: application/json' \\
		  --header 'X-JWS-SIGNATURE: #{token}' \\
		  --header 'cache-control: no-cache' \\
		  --header 'X-REQUEST-ID: 31800d2a-0dff-11ea-8d71-362b9e155667' \\
		  --data '#{json}' \\
		  --cert '#{path}/qwac.pem' \\
		  --key '#{path}/pwtkey.pem' \\
		  --insecure
		"
	  stdout, stderr, status = Open3.capture3(req)
	  JSON.parse(stdout)["aspspRedirectUri"]
  end

  def request uid
		{
		  "requestHeader":{
		    "requestId":"#{uid}",
		    "tppId":"PSDPL-KNF-1138278768"
		  },
		  "response_type":"code",
		  "client_id":"PSDPL-KNF-1138278768",
		  "redirect_uri":"http://localhost:3000/callback",
		  "scope":"ais-accounts",
		  "scope_details": {
		    "privilegeList": [
		      {
		        "accountNumber": "string",
		        "ais-accounts:getAccounts": {
		          "scopeUsageLimit": "single"
		        },
		        "ais:getAccount": {
		          "scopeUsageLimit": "single"
		        },
		        "ais:getHolds": {
		          "scopeUsageLimit": "single",
		          "maxAllowedHistoryLong": 0
		        },
		        "ais:getTransactionsDone": {
		          "scopeUsageLimit": "single",
		          "maxAllowedHistoryLong": 0
		        },
		        "ais:getTransactionsPending": {
		          "scopeUsageLimit": "single",
		          "maxAllowedHistoryLong": 0
		        },
		        "ais:getTransactionsRejected": {
		          "scopeUsageLimit": "single",
		          "maxAllowedHistoryLong": 0
		        },
		        "ais:getTransactionsCancelled": {
		          "scopeUsageLimit": "single",
		          "maxAllowedHistoryLong": 0
		        },
		        "ais:getTransactionsScheduled": {
		          "scopeUsageLimit": "single",
		          "maxAllowedHistoryLong": 0
		        },
		        "ais:getTransactionDetail": {
		          "scopeUsageLimit": "single"
		        },
		        "pis:getPayment": {
		          "scopeUsageLimit": "single",
		          "paymentId": "string",
		          "tppTransactionId": "string"
		        },
		        "pis:getBundle": {
		          "scopeUsageLimit": "single",
		          "bundleId": "string",
		          "tppBundleId": "string"
		        },
		        "pis:domestic": {
		          "scopeUsageLimit": "single",
		          "recipient": {
		            "accountNumber": "string",
		            "nameAddress": {
		              "value": [
		                "string"
		              ]
		            }
		          },
		          "sender": {
		            "accountNumber": "string",
		            "nameAddress": {
		              "value": [
		                "string"
		              ]
		            }
		          },
		          "transferData": {
		            "description": "string",
		            "amount": "string",
		            "executionDate": "2019-11-23",
		            "currency": "string"
		          },
		          "deliveryMode": "ExpressD0",
		          "system": "Elixir",
		          "executionMode": "Immediate"
		        },
		        "pis:EEA": {
		          "scopeUsageLimit": "single",
		          "recipient": {
		            "accountNumber": "string",
		            "nameAddress": {
		              "value": [
		                "string"
		              ]
		            }
		          },
		          "sender": {
		            "accountNumber": "string",
		            "nameAddress": {
		              "value": [
		                "string"
		              ]
		            }
		          },
		          "transferData": {
		            "description": "string",
		            "amount": "string",
		            "executionDate": "2019-11-23",
		            "currency": "string"
		          },
		          "deliveryMode": "ExpressD0",
		          "system": "SEPA",
		          "executionMode": "Immediate"
		        },
		        "pis:nonEEA": {
		          "scopeUsageLimit": "single",
		          "recipient": {
		            "accountNumber": "string",
		            "nameAddress": {
		              "value": [
		                "string"
		              ]
		            }
		          },
		          "recipientBank": {
		            "bicOrSwift": "string",
		            "name": "string",
		            "code": "string",
		            "countryCode": "string",
		            "address": [
		              "string"
		            ]
		          },
		          "sender": {
		            "accountNumber": "string",
		            "nameAddress": {
		              "value": [
		                "string"
		              ]
		            }
		          },
		          "transferData": {
		            "description": "string",
		            "amount": "string",
		            "executionDate": "2019-11-23",
		            "currency": "string"
		          },
		          "transferCharges": "string",
		          "deliveryMode": "ExpressD0",
		          "system": "Swift",
		          "executionMode": "Immediate"
		        },
		        "pis:tax": {
		          "scopeUsageLimit": "single",
		          "recipient": {
		            "accountNumber": "string",
		            "nameAddress": {
		              "value": [
		                "string"
		              ]
		            }
		          },
		          "sender": {
		            "accountNumber": "string",
		            "nameAddress": {
		              "value": [
		                "string"
		              ]
		            }
		          },
		          "transferData": {
		            "amount": "string",
		            "executionDate": "2019-11-23",
		            "currency": "string"
		          },
		          "usInfo": {
		            "payerInfo": {
		              "payorId": "string",
		              "payorIdType": "N"
		            },
		            "formCode": "string",
		            "periodId": "string",
		            "periodType": "string",
		            "year": 0,
		            "obligationId": "string"
		          },
		          "deliveryMode": "ExpressD0",
		          "system": "Elixir",
		          "executionMode": "Immediate"
		        },
		        "pis:cancelPayment": {
		          "scopeUsageLimit": "single",
		          "paymentId": "string",
		          "bundleId": "string"
		        },
		        "pis:bundle": {
		          "scopeUsageLimit": "single",
		          "transfersTotalAmount": "string",
		          "typeOfTransfers": "domestic",
		          "domesticTransfers": [
		            {
		              "recipient": {
		                "accountNumber": "string",
		                "nameAddress": {
		                  "value": [
		                    "string"
		                  ]
		                }
		              },
		              "sender": {
		                "accountNumber": "string",
		                "nameAddress": {
		                  "value": [
		                    "string"
		                  ]
		                }
		              },
		              "transferData": {
		                "description": "string",
		                "amount": "string",
		                "executionDate": "2019-11-23",
		                "currency": "string"
		              },
		              "tppTransactionId": "string",
		              "deliveryMode": "ExpressD0",
		              "system": "Elixir",
		              "hold": true,
		              "executionMode": "Immediate"
		            }
		          ],
		          "EEATransfers": [
		            {
		              "recipient": {
		                "accountNumber": "string",
		                "nameAddress": {
		                  "value": [
		                    "string"
		                  ]
		                }
		              },
		              "sender": {
		                "accountNumber": "string",
		                "nameAddress": {
		                  "value": [
		                    "string"
		                  ]
		                }
		              },
		              "transferData": {
		                "description": "string",
		                "amount": "string",
		                "executionDate": "2019-11-23",
		                "currency": "string"
		              },
		              "tppTransactionId": "string",
		              "deliveryMode": "ExpressD0",
		              "system": "SEPA",
		              "hold": true,
		              "executionMode": "Immediate"
		            }
		          ],
		          "nonEEATransfers": [
		            {
		              "recipient": {
		                "accountNumber": "string",
		                "nameAddress": {
		                  "value": [
		                    "string"
		                  ]
		                }
		              },
		              "recipientBank": {
		                "bicOrSwift": "string",
		                "name": "string",
		                "code": "string",
		                "countryCode": "string",
		                "address": [
		                  "string"
		                ]
		              },
		              "sender": {
		                "accountNumber": "string",
		                "nameAddress": {
		                  "value": [
		                    "string"
		                  ]
		                }
		              },
		              "transferData": {
		                "description": "string",
		                "amount": "string",
		                "executionDate": "2019-11-23",
		                "currency": "string"
		              },
		              "transferCharges": "string",
		              "tppTransactionId": "string",
		              "deliveryMode": "ExpressD0",
		              "system": "Swift",
		              "hold": true,
		              "executionMode": "Immediate"
		            }
		          ],
		          "taxTransfers": [
		            {
		              "recipient": {
		                "accountNumber": "string",
		                "nameAddress": {
		                  "value": [
		                    "string"
		                  ]
		                }
		              },
		              "sender": {
		                "accountNumber": "string",
		                "nameAddress": {
		                  "value": [
		                    "string"
		                  ]
		                }
		              },
		              "transferData": {
		                "amount": "string",
		                "executionDate": "2019-11-23",
		                "currency": "string"
		              },
		              "usInfo": {
		                "payerInfo": {
		                  "payorId": "string",
		                  "payorIdType": "N"
		                },
		                "formCode": "string",
		                "periodId": "string",
		                "periodType": "string",
		                "year": 0,
		                "obligationId": "string"
		              },
		              "tppTransactionId": "string",
		              "deliveryMode": "ExpressD0",
		              "system": "Elixir",
		              "hold": true,
		              "executionMode": "Immediate"
		            }
		          ]
		        },
		        "pis:recurring": {
		          "scopeUsageLimit": "single",
		          "recurrence": {
		            "startDate": "2019-11-23",
		            "frequency": {
		              "periodType": "day",
		              "periodValue": 0
		            },
		            "endDate": "2019-11-23",
		            "dayOffOffsetType": "before"
		          },
		          "typeOfPayment": "domestic",
		          "domesticPayment": {
		            "recipient": {
		              "accountNumber": "string",
		              "nameAddress": {
		                "value": [
		                  "string"
		                ]
		              }
		            },
		            "sender": {
		              "accountNumber": "string",
		              "nameAddress": {
		                "value": [
		                  "string"
		                ]
		              }
		            },
		            "transferData": {
		              "description": "string",
		              "amount": "string",
		              "executionDate": "2019-11-23",
		              "currency": "string"
		            },
		            "deliveryMode": "ExpressD0",
		            "system": "Elixir",
		            "hold": true
		          },
		          "EEAPayment": {
		            "recipient": {
		              "accountNumber": "string",
		              "nameAddress": {
		                "value": [
		                  "string"
		                ]
		              }
		            },
		            "sender": {
		              "accountNumber": "string",
		              "nameAddress": {
		                "value": [
		                  "string"
		                ]
		              }
		            },
		            "transferData": {
		              "description": "string",
		              "amount": "string",
		              "executionDate": "2019-11-23",
		              "currency": "string"
		            },
		            "deliveryMode": "ExpressD0",
		            "system": "SEPA",
		            "hold": true
		          },
		          "nonEEAPayment": {
		            "recipient": {
		              "accountNumber": "string",
		              "nameAddress": {
		                "value": [
		                  "string"
		                ]
		              }
		            },
		            "recipientBank": {
		              "bicOrSwift": "string",
		              "name": "string",
		              "code": "string",
		              "countryCode": "string",
		              "address": [
		                "string"
		              ]
		            },
		            "sender": {
		              "accountNumber": "string",
		              "nameAddress": {
		                "value": [
		                  "string"
		                ]
		              }
		            },
		            "transferData": {
		              "description": "string",
		              "amount": "string",
		              "executionDate": "2019-11-23",
		              "currency": "string"
		            },
		            "transferCharges": "string",
		            "deliveryMode": "ExpressD0",
		            "system": "Swift",
		            "hold": true
		          },
		          "taxPayment": {
		            "recipient": {
		              "accountNumber": "string",
		              "nameAddress": {
		                "value": [
		                  "string"
		                ]
		              }
		            },
		            "sender": {
		              "accountNumber": "string",
		              "nameAddress": {
		                "value": [
		                  "string"
		                ]
		              }
		            },
		            "transferData": {
		              "amount": "string",
		              "executionDate": "2019-11-23",
		              "currency": "string"
		            },
		            "usInfo": {
		              "payerInfo": {
		                "payorId": "string",
		                "payorIdType": "N"
		              },
		              "formCode": "string",
		              "periodId": "string",
		              "periodType": "string",
		              "year": 0,
		              "obligationId": "string"
		            },
		            "deliveryMode": "ExpressD0",
		            "system": "Elixir",
		            "hold": true
		          }
		        },
		        "pis:getRecurringPayment": {
		          "scopeUsageLimit": "single",
		          "recurringPaymentId": "string",
		          "tppRecurringPaymentId": "string"
		        },
		        "pis:cancelRecurringPayment": {
		          "scopeUsageLimit": "single",
		          "recurringPaymentId": "string"
		        }
		      }
		    ],
		    "scopeGroupType":"ais-accounts",
		    "consentId":"#{uid}",
		    "scopeTimeLimit":"2020-02-13T13:34:41.828Z",
		    "throttlingPolicy":"psd2Regulatory"
		  },
		  "state":"92268605-0243-4608-832c-6c70b67f9292"
		}
	end
end
