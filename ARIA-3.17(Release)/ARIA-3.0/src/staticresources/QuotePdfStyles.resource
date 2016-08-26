th {
    text-align: left;
    font-weight: bold;
    white-space: nowrap;
}

td {
	vertical-align: top;
	font-family: sans-serif;
        font-size: 11;
}

.quoteheader {
	border-bottom: 1px solid black;
	font-family: sans-serif;
        font-size: 11;
}

form {
    margin:0px;
    padding:0px;
}

h1, h2, h3, h4, h5, h6 {
    font-family: 'Verdana', 'Geneva', sans-serif;
    font-size: 100%;
    margin:0px;
    display:inline;
}

textarea {
    font-family: sans-serif;
    font-size: 11;
 }

img { border:0; }

.highlightcol {
    background-color: #CCCCCC;
}

.infobox {
  border: 1px dashed #CCCCCC;
  font-size: 70%;
}

.extendedrenewalcol {
  background-color: #33CCCC;
}

.tablehead {
    border: 1px dashed #33CCCC;
    background-color: #0099FF;
    font-weight: bold;
}

.totals {
    background-color: #0099FF;
    font-weight: bold;
}

.infohead {
  font-size: 70%;
  font-weight: bold;
}

.odd {
 background-color: #E3E3E3;
}

.even {
 border-bottom: 1px solid #000;
 padding: 1px 1px 2px 2px;

}

@page {
/* Landscape orientation 
size:landscape;
*/

/* Put page numbers in the top right corner of each
   page in the pdf document. */

.page-break_in_block  { display:block; page-break-after:always; }

@bottom-right {
 content: counter(page) ;
}
}


@media print
{
  .page-break  { display:block; page-break-after:always; }
}