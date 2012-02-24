<?php

$file = fopen("levels.dat", "w");

for($i=1; $i<=120; $i++) {
	$contents = file_get_contents("level".$i.".txt");
	$lines = explode("\n", $contents);
	$data = trim($lines[0]).trim($lines[1]).trim($lines[2]).trim($lines[3]).trim($lines[4]).trim($lines[5]).trim($lines[6]).trim($lines[7]);
	$min_moves = trim($lines[8]);
        echo "Data: ".$data." moves: ".$min_moves."\n";
        fwrite($file, "$i;$data;$min_moves;0;0;0;0;0\n");
}

fclose($file);

echo "Wrote levels.dat\n";

?>
