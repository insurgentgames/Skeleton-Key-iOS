<?php

$file = fopen("levels.sql", "w");
fwrite($file, "CREATE TABLE level (num INTEGER,data TEXT,min_moves INTEGER,complete INTEGER,complete_easy INTEGER,complete_medium INTEGER,complete_hard INTEGER);\n");

for($i=1; $i<=120; $i++) {
	$contents = file_get_contents("level".$i.".txt");
	$lines = explode("\n", $contents);
	$data = trim($lines[0]).trim($lines[1]).trim($lines[2]).trim($lines[3]).trim($lines[4]).trim($lines[5]).trim($lines[6]).trim($lines[7]);
	$min_moves = trim($lines[8]);
	//echo "Data: ".$data."\nMin moves: ".$min_moves."\n\n";
	fwrite($file, "INSERT INTO level (num,data,min_moves,complete,complete_easy,complete_medium,complete_hard) VALUES('".$i."','".$data."','".$min_moves."','0','0','0','0');\n");
}

fclose($file);

echo "Wrote levels.sql\n";

?>
