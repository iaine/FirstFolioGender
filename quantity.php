<?php
/**
*  Provides a quantitative analysis
*/

// extract data takes the short code and converts into a url
function extract_data ($short) {

  $xml_str = open_file($short);  

  $reader = new XMLReader();

  if (!$reader->open($xml_str)) {
    die("Failed to open First Folio");
  }

  $pid = 1;
  $act = 0;
  $play = array();
  $playAct = array();
  $person = array();
  $id = $name = '';
  $sex = '';
    $inner = array(); //the array of who is on stage
  while($reader->read()) {

    if ($reader->nodeType == XMLReader::ELEMENT && $reader->name == 'person') {  
      $id = $reader->getAttribute('xml:id');
      $sex = $reader->getAttribute('sex');
      $pid++;
    }
    if ($id) {
       $person{$id} = array('id' => $pid, 'sex'=> $sex);
    }

    // parse the play sections
    if ($reader->nodeType == XMLReader::ELEMENT && $reader->name == 'div') {
      $divtype = $reader->getAttribute('type');
      if ($divtype == 'act') {
        $act = $reader->getAttribute('n');
      }
    }

    if ($reader->nodeType == XMLReader::ELEMENT && $reader->name == 'sp') {
      $speaker = substr($reader->getAttribute('who'), 1);
    }
    //get the character
    if ($reader->nodeType == XMLReader::ELEMENT && ($reader->name == 'l' || $reader->name == 'p')) {
       if ($act > 0 ) {
         $playAct[$act][$person[$speaker]['sex']] += 1;
         $play[$person[$speaker]['sex']] += 1;
       }
    }
  }
  
  $reader->close();
    
  return array($playAct, $play);
}

function open_file($code) {
   return "/Users/iain.emsley/git/BodleianFirstFolio/texts/F-$code.xml";
}

function write_file($play_coords, $filename) {
   $fh = fopen($filename, 'wb');
   if (!$fh) {
     die('Could not open file to write data');
   }
   fwrite($fh, $play_coords);
   fclose($fh);
}

if (sizeof($argv) < 1) {
   die('Usage: xml_transform.php <shortcode here>');
   exit();
}

$code = $argv[1];

echo "Extracting the data from $code. \n";

$count = extract_data($code);
print json_encode($count[0]);
$json = "{\"data\": [";
foreach ($count[0] as $actV => $speak) {
    $json .= "{ \"act\": $actV, ";
    $_tmp = '';
    foreach ($speak as $gender => $freq) {
        $_tmp .= '"'.$gender .'" :'. $freq .',';
    }
    $json .= substr($json, 0, -1) .'},';
    $_tmp = '';
}
$json = substr($json, 0, -1) . "]}";
write_file($json, "docs/mnd_gender.json");


write_file("{ \"data\":". json_encode($count[1]) . "}", "docs/mnd_quant.json");
?>
