let selectedFile = '';

function AddCell() {
    let colCount = $j('.tableX').columnCount() + 1;
    let newColName = $j("#col_name").val();
    if (newColName.length < 3) {
        alert("Please enter a valid column name!");
        return;
    }
    $j('.tableX').find('thead').find('th').eq(colCount - 2).after('<th>' + newColName + '</th>');


    $j('.tableX').find('tr').each(function() {
        $j(this).find('td').eq(colCount - 2).after('<td>TBD</td>');
    });
}

$j.fn.columnCount = function() {
    return $j('th', $j(this).find('thead')).length;
};

$j.fn.rowcount = function() {
    return $j('tr', $j(this).find('tbody')).length;
};

function AddRow() {
    let rowCount = $j('.tableX').rowcount() + 1;

    // console.log($j('.table tbody tr:last-child').html())
    let newRow;
    $j('.tableX thead tr').find('th').each(function() {
        newRow += '<td>TBD</td>'
    });
    $j('.tableX tbody').append('<tr>' + newRow + '</tr>')

}


$j(document).ready(function() {
    $j(".table").on('click', 'td', function() {

        if ($j(this).attr("contentEditable") == true) {
            $j(this).attr("contentEditable", "false");
        } else {
            $j(this).attr("contentEditable", "true");
        }
    });

    $j('.sample_sources_id').on('change', function() {
        if (this.value)
            populateSampleSourceTable(this.value)
    });

    populateSampleSourceTable("1")

});


function ExportJSON() {
    var tbl = $j('.table tbody tr').map(function(idxRow, ele) {
        //
        // start building the retVal object
        //
        var retVal = {
            id: ++idxRow
        };
        //
        // for each cell
        //

        var $td = $j(ele).find('td').map(function(idxCell, ele) {
            var input = $j(ele).find(':input');
            //
            // if cell contains an input or select....
            //
            if (input.length == 1) {
                var attr = $j('.table thead tr th').eq(idxCell).text();
                retVal[attr] = input.val();
            } else {
                var attr = $j('.table thead tr th').eq(idxCell).text();
                retVal[attr] = $j(ele).text();
            }
        });
        return retVal;
    }).get();

    console.log(tbl);
}

function setCookie(c_name, value, expireminutes) {
    var exdate = new Date();
    exdate.setMinutes(exdate.getMinutes() + expireminutes);
    document.cookie = c_name + "=" + escape(value) +
        ((expireminutes == null) ? "" : ";expires=" + exdate.toUTCString());
}

function getCookie(c_name) {
    if (document.cookie.length > 0) {
        c_start = document.cookie.indexOf(c_name + "=");
        if (c_start != -1) {
            c_start = c_start + c_name.length + 1;
            c_end = document.cookie.indexOf(";", c_start);
            if (c_end == -1) c_end = document.cookie.length;
            return unescape(document.cookie.substring(c_start, c_end));
        }
    }
    return "";
}

function populateSampleSourceTable(sourceId) {
    let cols = ['Developmental stage', 'Material Type', 'Organism', 'Organism part', 'Age', 'Genotype',
        'Disease', 'Individual', 'Sex', 'Cell line', 'Cell type', 'Cultivar', 'Strain'
    ];
    let Animal_tissue = [1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1];
    let Cell_line = [1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0];
    let Human_tissue = [1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0];
    let Plant = [1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0];
    let temp = "";

    $j(".tableX thead tr").remove();
    $j(".tableX tr").remove();

    switch (sourceId) {
        case "1":
            {
                for (let i = 0; i < Animal_tissue.length; i++) {
                    temp += Animal_tissue[i] ? '<th scope="col">' + cols[i] + '</th>' : ''
                }
                break;
            }
        case "2":
            {
                for (let i = 0; i < Cell_line.length; i++) {
                    temp += Cell_line[i] ? '<th scope="col">' + cols[i] + '</th>' : ''
                }
                break;
            }
        case "3":
            {
                for (let i = 0; i < Human_tissue.length; i++) {
                    temp += Human_tissue[i] ? '<th scope="col">' + cols[i] + '</th>' : ''
                }
                break;
            }
        case "4":
            {
                for (let i = 0; i < Plant.length; i++) {
                    temp += Plant[i] ? '<th scope="col">' + cols[i] + '</th>' : ''
                }
                break;
            }
    }

    $j('.tableX thead').append('<tr>' + temp + '</tr>');


}


$j(".UL").on("click", ".file", function(event) {
    let R = $j('.tableX').prop('outerHTML')
    setCookie(selectedFile, R, 1000000)

    let fileName = $j(this).text();

    let E = getCookie(fileName);
    if (E.length > 60) {
        $j('.tableX').empty();
        $j('.tableX').html(E)
    }
    selectedFile = fileName;
    $j('.UL li').each(function() {
        $j(this).removeClass("file_selected")
    });
    $j(this).parent().addClass("file_selected")

});