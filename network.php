<?php

// extract data takes the short code and converts into a url
function extract_data ($short) {

  $xml_str = open_file($short);  

  $reader = new XMLReader();

  if (!$reader->open($xml_str)) {
    die("Failed to open First Folio $xml_str");
  }
  $num_items=0;
  $pid = 1;
  $act = $scene = $line = 0;
  $play = '';
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
     /* if ($divtype == 'scene') {
        $play .= 50  + $reader->getAttribute('n').' ';
      }*/
    }

    if ($reader->nodeType == XMLReader::ELEMENT && $reader->name == 'sp') {
      $speaker = substr($reader->getAttribute('who'), 1);
    }
    //get the character
    if ($reader->nodeType == XMLReader::ELEMENT && ($reader->name == 'l' || $reader->name == 'p')) {
       $num_items++;
       if ($act > 0) {
         $play .= "$act," . map_sex_markup($person[$speaker]['id'], $person[$speaker]['sex']) .','. join(',',$inner)."\n";
       }
       /*if (!$person[$speaker]['sex']) {
          $play .= "$act," . (60 + $person[$speaker]['id']) .','. join(',',$inner)."\n";
       } else if ($person[$speaker]['sex'] == 'M') {
          $play .= "$act," . (127 + $person[$speaker]['id']) .','. join(',',$inner)."\n";
       } else {
          $play .= "$act," . (210 + $person[$speaker]['id']) .','. join(',',$inner)."\n";
       } */
    }

    // get the types of stage direction
    if ($reader->nodeType == XMLReader::ELEMENT && $reader->name == 'stage') {
       $type = $reader->getAttribute('type');
       if ($type == 'entrance') {
           $inner2 = $inner;
           // add the id to the inner circle

           if (strstr($reader->getAttribute('who'),',') !== false) {
               foreach (explode(',',$reader->getAttribute('who')) as $on) {
                   array_push($inner2, map_sex_markup($person[substr($on,1)]['id'], $person[substr($on,1)]['sex']));
               }
           } else {
               array_push($inner2, map_sex_markup($person[substr($reader->getAttribute('who'),1)]['id'],$person[substr($reader->getAttribute('who'),1)]['sex'] ));
           }
           // filter out any null variables
           $inner = array_unique(array_filter($inner2, function($var){return !is_null($var);}));
       } else if ($type == 'exit') {
           $inner2 = $inner;
           // remove the id from the attribute
           if (strstr($reader->getAttribute('who'),',') !== false) {
               foreach (explode(',',$reader->getAttribute('who')) as $on) {
                   if ($key = array_keys($inner2, map_sex_markup($person[substr($on,1)]['id'],$person[substr($on,1)]['sex']))) {
                         foreach($key as $k) {
                           unset($inner2[$k]);
                         }
                   }
               }
           } else {
               if ($key = array_keys($inner2, map_sex_markup($person[substr($on,1)]['id'],$person[substr($on,1)]['sex']))) {
                   foreach($key as $k) {
                      unset($inner2[$k]);
                   }
               }
           }
           $inner = array_unique(array_filter($inner2, function($var){return !is_null($var);}));
       }
    }
  }
    // We want an array structure for the Act, Spekaer, Who's On stage
    // We need the act for a channel experiment.
    // We need speaker for the main tone
    // We need the speakers as an array for the background sounds and rhythms
  $play = substr($play, 0, -1);
  $reader->close();
  
  return $play;
}

function map_sex_markup($id, $sex) {
    if ($sex == '') {
        return (60 + $id);
    } else if ($sex == 'M') {
        return (127 + $id);
    } else {
        return (210 + $id);
    }
}

function open_file($code) {
   return "/Users/iain.emsley/git/BodleianFirstFolio/texts/F-$code.xml";
}

function write_chuck_file($play_coords) {
   $fh = fopen('mnd.txt', 'wb');
   if (!$fh) {
     die('Could not open file to write data');
   }
   //fwrite($fh, sizeof(explode(" ",$play_coords)) . " ");
   fwrite($fh, $play_coords);
   fclose($fh);
}

if (sizeof($argv) < 1) {
   die('Usage: xml_transform.php <shortcode here>');
   exit();
}

$code = $argv[1];

echo "Extracting the data from $code. \n";

$drama_coords = extract_data($code);

echo "Writing the data to file";

write_chuck_file($drama_coords);

echo "File written";
?>
