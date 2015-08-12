<?php

$credUri = 'http://192.168.50.4:8200/v1/mysql/creds/readonly';
$apiKey = file_get_contents('/vagrant/vault-root-token');

echo "Obtaining credentials...\n";
$start = microtime(true);
// Getting MySQL credentials
$ch = curl_init();
curl_setopt_array($ch, array(
	CURLOPT_URL => $credUri,
	CURLOPT_HTTPHEADER => array('X-Vault-Token: ' . $apiKey),
	CURLOPT_RETURNTRANSFER => 1
	));
echo "Executing curl call\n";
if ( ! $result = curl_exec($ch)) {
	echo "CURL error: " . curl_error($ch);
}
$data = json_decode($result);
printf("Got results, maybe, in %.02f ms. User: %s. Pass: %s.\n", (microtime(true)-$start)*1000, $data->data->username, $data->data->password);
echo "Connecting...\n";
$db = new mysqli('192.168.50.3', $data->data->username, $data->data->password);

$res = query($db, "SHOW VARIABLES LIKE 'version'");
printf("Connected! Server: %s\n", $res[0]['Value']);

$res = query($db, "SHOW DATABASES");
echo "Available databases: \n";
foreach ($res as $row) {
	printf("  %s\n", $row[0]);
}

function query($db, $sql) {
	if ( ($res = $db->query($sql))=== false) {
		printf("Error during query: %s", $db->error);
		return null;
	}
	$ret = array();
	while ($row = $res->fetch_array()) {
		$ret[] = $row;
	}
	return $ret;
}