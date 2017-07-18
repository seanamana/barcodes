void setup()
{
  background(255); 


  size(270, 1020);
  int barcodeSpacing = 32;
  int numCodes = floor((height - 20)/barcodeSpacing); 

  String[] codes = new String[numCodes];

  int prefixed = 4;
  String prefix = "020717";
  String suffix = "3";


  for (int v = 0; v < codes.length; v++)
  {
    String randcode = "";
    if (v < prefixed)
    {
      randcode += prefix;
      for (int w = prefix.length(); w < 9; w++)
      {
        randcode += floor(random(0, 10));
      }
    } else
    {
      for (int w = 0; w < 9; w++)
      {
        randcode += floor(random(0, 10));
      }
    }
    randcode += suffix;
    codes[v] = randcode;
  }

  PFont font;
  font = loadFont("ArialRoundedMTBold-10.vlw");
  textFont(font);

  int[] pixelArray = new int[codes.length*11+11+11+11+2]; // start (11) plus code (11 * length) plus checksum (11) plus stop (13) 
  int checksum = 0;
  String[] lookup = { //regexed from Code_128 on wikipedia. "0" is at position 16
    "11011001100", 
    "11001101100", 
    "11001100110", 
    "10010011000", 
    "10010001100", 
    "10001001100", 
    "10011001000", 
    "10011000100", 
    "10001100100", 
    "11001001000", 
    "11001000100", 
    "11000100100", 
    "10110011100", 
    "10011011100", 
    "10011001110", 
    "10111001100", 
    "10011101100", 
    "10011100110", 
    "11001110010", 
    "11001011100", 
    "11001001110", 
    "11011100100", 
    "11001110100", 
    "11101101110", 
    "11101001100", 
    "11100101100", 
    "11100100110", 
    "11101100100", 
    "11100110100", 
    "11100110010", 
    "11011011000", 
    "11011000110", 
    "11000110110", 
    "10100011000", 
    "10001011000", 
    "10001000110", 
    "10110001000", 
    "10001101000", 
    "10001100010", 
    "11010001000", 
    "11000101000", 
    "11000100010", 
    "10110111000", 
    "10110001110", 
    "10001101110", 
    "10111011000", 
    "10111000110", 
    "10001110110", 
    "11101110110", 
    "11010001110", 
    "11000101110", 
    "11011101000", 
    "11011100010", 
    "11011101110", 
    "11101011000", 
    "11101000110", 
    "11100010110", 
    "11101101000", 
    "11101100010", 
    "11100011010", 
    "11101111010", 
    "11001000010", 
    "11110001010", 
    "10100110000", 
    "10100001100", 
    "10010110000", 
    "10010000110", 
    "10000101100", 
    "10000100110", 
    "10110010000", 
    "10110000100", 
    "10011010000", 
    "10011000010", 
    "10000110100", 
    "10000110010", 
    "11000010010", 
    "11001010000", 
    "11110111010", 
    "11000010100", 
    "10001111010", 
    "10100111100", 
    "10010111100", 
    "10010011110", 
    "10111100100", 
    "10011110100", 
    "10011110010", 
    "11110100100", 
    "11110010100", 
    "11110010010", 
    "11011011110", 
    "11011110110", 
    "11110110110", 
    "10101111000", 
    "10100011110", 
    "10001011110", 
    "10111101000", 
    "10111100010", 
    "11110101000", 
    "11110100010", 
    "10111011110", 
    "10111101110", 
    "11101011110", 
    "11110101110"
  };
  String start = "11010010000";
  String stop  = "1100011101011";

  for (int r = 0; r < codes.length; r++)
  {
    checksum = 0;
    String code = codes[r];
    println(code);
    for (int j = 0; j < start.length(); j++)
    {
      pixelArray[j] = start.charAt(j) - 48; // values are (int)0 or 1
    }

    for (int i = 0; i < code.length(); i++)
    {
      int x = code.charAt(i) - 48 + 16; // the 128 specification puts 0 at position 16 (stupid), while ascii puts 0 at 48
      // obviously, non-numbers will break this pretty hard
      checksum += x * (i+1); 
      String bin = lookup[x];

      for (int k = 0; k < 11; k++)
      {
        pixelArray[(i+1)*11+k] = bin.charAt(k) - 48; // the lookup table returns a string, which means that it's in ascii, which puts 0 at 48
      }
    }
    int checkdigit = (checksum + 1) % 103; // i don't know why it's off by 1 but I think this fixes it

    println(checkdigit);

    String checkdigitbin = lookup [checkdigit];
    println(checkdigitbin);

    for (int p = 0; p < checkdigitbin.length(); p++)
    {
      pixelArray[11+code.length()*11+p] = checkdigitbin.charAt(p) - 48; // checkdigitbin is a string
    }

    for (int m = 0; m < stop.length(); m++)
    {
      pixelArray[11+code.length()*11+11+m] = stop.charAt(m) - 48; // values are (int)0 or 1
    }


    for (int q = 0; q < pixelArray.length; q++)
    {
      stroke(255-pixelArray[q]*255);
      line(q+20, 5+r*barcodeSpacing, q+20, 20+r*barcodeSpacing);
    }

    fill(0);
    text(code, 175, 17+r*barcodeSpacing);
  }

  save("barcodes.png");
}

void draw()
{
}