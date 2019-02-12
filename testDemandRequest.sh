#!/bin/bash
# jq --version > /dev/null 2>&1
# if [ $? -ne 0 ]; then
# 	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
# 	echo
# 	exit 1
# fi
 starttime=$(date +%s)

echo "POST request Enroll on Org1  ..."
echo
ORG1_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Jim&orgName=org1')
echo $ORG1_TOKEN
ORG1_TOKEN=$(echo $ORG1_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token is $ORG1_TOKEN"
echo
echo


# echo "POST request Create channel  ..."
# echo
# TRX_ID=$(curl -s -X POST \
#   http://localhost:4000/channels \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json" \
#   -d '{
#   "channelName":"mychannel",
#   "channelConfigPath":"../artifacts/channel/mychannel.tx"
# }')
# echo "Transacton ID is $TRX_ID"
# echo
# echo
# sleep 5
# echo "POST request Join channel on Org1"
# echo
# TRX_ID=$(curl -s -X POST \
#   http://localhost:4000/channels/mychannel/peers \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json" \
#   -d '{
#   "peers": ["peer1","peer2"]
# }')
# echo "Transacton ID is $TRX_ID"
# echo
# echo

echo "POST Install chaincode on Org1"
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1", "peer2"],
	"chaincodeName":"DemandRequestCC",
	"chaincodePath":"github.com/chaincodes/DemandRequest",
	"chaincodeVersion":"v1"
}')
echo "Transacton ID is $TRX_ID"
echo
echo

echo "POST instantiate chaincode on peer1 of Org1"
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"chaincodeName":"DemandRequestCC",
	"chaincodeVersion":"v1",
	"args":[]
}')
echo "Transacton ID is $TRX_ID"
echo
echo

echo "POST invoke chaincode on peers of Org1"
echo "create a DemandRequest...."
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"fcn":"createDemandRequest",
	"args":["DR1", "PR1","100", "1000", "EC","GT", "13/12/2017",  "0", "cus1", "uni1","cus1", "cus1", "12/12/2017"]
}')
echo "Transacton ID is $TRX_ID"
echo
echo "DemandRequest created successfully"

echo "GET query chaincode on peer1 of Org1"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getDemandRequestByID&args=%5B%22DR1%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "POST invoke chaincode on peers of Org1"
echo "create a DemandRequest...."
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
  "fcn":"createDemandRequest",
  "args":["DR2", "PR2","100", "1000", "EC","GT", "13/12/2017",  "0", "cus1", "uni1", "cus2", "cus1", "12/12/2017"]
}')
echo "Transacton ID is $TRX_ID"
echo
echo "DemandRequest created successfully"

echo "GET query chaincode on peer1 of Org1"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getDemandRequestByID&args=%5B%22DR2%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "POST invoke chaincode on peers of Org1"
echo "create a DemandRequest...."
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
  "fcn":"createDemandRequest",
  "args":["DR3", "PR3","100", "1000", "EC","GT", "13/12/2017",  "0", "cus2", "uni1", "cus2", "cus2", "12/12/2017"]
}')
echo "Transacton ID is $TRX_ID"
echo
echo "DemandRequest created successfully"

echo "GET query chaincode on peer1 of Org1"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getDemandRequestByID&args=%5B%22DR3%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "update a DemandRequest...."
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
  "fcn":"updateDemandRequest",
  "args":["DR1","PR1","500","5000","GD","TR","14/12/2017","Uniper Accepted","uni1","uni1"]
}')
echo "Transacton ID is $TRX_ID"
echo
echo "updated the DemandRequest successfully"

echo "GET query chaincode on peer1 of Org1"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getDemandRequestByID&args=%5B%22DR1%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "update a DemandRequest...."
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
  "fcn":"updateDemandRequest",
  "args":["DR1","PR1","500","5000","GD","TF","14/12/2017","Customer Accepted","cus1","cus1"]
}')
echo "Transacton ID is $TRX_ID"
echo
echo "updated the DemandRequest successfully"

echo "GET query chaincode on peer1 of Org1"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getDemandRequestByID&args=%5B%22DR1%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "getting All DemandRequests...."
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getAllDemandRequests&args=%5B%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo "Fetched All DemandRequests...."
echo

echo "getting All DemandRequests by Customer...."
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getDemandRequestByCustomer&args=%5B%22cus1%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo "Fetched All DemandRequests by Customer...."
echo

echo "getting All DemandRequests by Status...."
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getDemandRequestByStatus&args=%5B%22Confirmed%20Trade%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo "Fetched All DemandRequests by Status...."
echo

echo "getting DemandRequests's History...."
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getDemandRequestHistory&args=%5B%22DR1%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo "Fetched DemandRequest's History...."
echo

echo "getting Confirmed Trade For Customer...."
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getConfirmedTradeForCustomer&args=%5B%22cus1%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo "Fetched Confirmed Trade For Customer...."
echo

echo "getting Confirmed Trade For Supplier...."
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getConfirmedTradeForSupplier&args=%5B%22sup1%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo "Fetched Confirmed Trade For Supplier...."
echo

echo "getting Confirmed Trade For Transporter...."
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getConfirmedTradeForTransporter&args=%5B%22tr1%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo "Fetched Confirmed Trade For Transporter...."
echo

echo "getting Confirmed Trade For Uniper...."
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getConfirmedTradeForUniper&args=%5B%22uni1%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo "Fetched Confirmed Trade For Uniper...."
echo

echo "deleting a DemandRequest...."
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
  "fcn":"deleteDemandRequest",
  "args":["DR3"]
}')
echo "Transacton ID is $TRX_ID"
echo "deleted a DemandRequest"
echo
echo

echo "GET query chaincode on peer1 of Org1"
echo "Fetching a deleted DemandRequest by ID"
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/DemandRequestCC?peer=peer1&fcn=getDemandRequestByID&args=%5B%22DR3%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
