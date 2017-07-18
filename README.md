A processing sketch for generating a list of random numeric barcodes to the Code 128 specification.

My specific use case basically only used the last digit for classification and ignored the rest, so the last digit is configurable. I also wanted to be able to track batches by embedding the date or some other human readable string, so a prefix is also configurable.