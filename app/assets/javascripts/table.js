let selectedFile = '';

function AddCell(table, newColName) {
    let colCount = $j(table).columnCount() + 1;
    if (newColName.length < 3) {
        alert("Please enter a valid column name!");
        return;
    }
    $j(table).find('thead').find('th').eq(colCount - 2).after('<th>' + newColName + '</th>');


    $j(table).find('tr').each(function() {
        $j(this).find('td').eq(colCount - 2).after('<td>TBD</td>');
    });
}

$j.fn.columnCount = function() {
    return $j('th', $j(this).find('thead')).length;
};

$j.fn.rowcount = function() {
    return $j('tr', $j(this).find('tbody')).length;
};

function AddRow(table) {
    let rowCount = $j(table).rowcount() + 1;
    // console.log($j('.table tbody tr:last-child').html())
    let newRow;
    $j(table + ' thead tr').find('th').each(function() {
        newRow += '<td>TBD</td>'
    });
    $j(table + ' tbody').append('<tr>' + newRow + '</tr>')
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
}

function setCookie(c_name, value, expireminutes, ) {

    var exdate = new Date();
    exdate.setMinutes(exdate.getMinutes() + expireminutes);
    document.cookie = c_name + "=" + encodeURIComponent(value) +
        ((expireminutes == null) ? "" : ";expires=" + exdate.toUTCString());
}

function getCookie(c_name) {
    if (document.cookie.length > 0) {
        c_start = document.cookie.indexOf(c_name + "=");
        if (c_start != -1) {
            c_start = c_start + c_name.length + 1;
            c_end = document.cookie.indexOf(";", c_start);
            if (c_end == -1) c_end = document.cookie.length;
            return decodeURIComponent(document.cookie.substring(c_start, c_end));
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
    $j('#tableContainer').hide();
    $j('#workflowContainer').hide();
    let fileName = $j(this).text();
    if (fileName == "Sample Source") {
        let E = getCookie(fileName);
        if (E.length > 60) {
            $j('.tableX').empty();
            $j('.tableX').html(E);
            $j('#tableContainer').show();
        }
    } else if (fileName == "Study workflow") {
        $j('#workflowContainer').show();
        //  loadWorkflow();
    }
    // selectedFile = fileName;
    $j('.UL li').each(function() {
        $j(this).removeClass("file_selected")
    });
    $j(this).parent().addClass("file_selected")


    let selectedFIle = $j(this).html();
    setCookie("selectedFIle", selectedFIle, 1000000)
        //-----------SHOW CONTENT---------------
    let fileType = $j(this).data('filetype');
    if (fileType == "txt") {
        $j('#txt_file_content').show();
        let content = getCookie(selectedFIle)
        $j('#txt_file_content').val(content.length > 0 ? content.replace(new RegExp("<br/>", "g"), '\n') : '')
    } else if (fileType == "tbl") {
        showAssayTable($j(this), selectedFIle)
    }

});

function showAssayTable(T, selectedFIle) {
    $j("#tbl_file_content").show();
    $j(".tableInpOut thead tr").remove();
    $j(".tableInpOut tr").remove();
    let content = getCookie(selectedFIle)
    let index = T.parent().index()
    let predefCols
    if (index == 0) {
        predefCols = ['Species', 'Strain', 'Source', 'Source origins', 'Growth medium', 'Growth temperature', 'Unit']
    } else if (index == 1) {
        predefCols = ['Start treatment', 'Calibration']
    } else if (index == 2) {
        predefCols = ['Exraction data', 'Experimentalist', 'Concentration', 'Unit', '260/280', '260/230', 'Volume', 'Solvent', 'DNAse treatment', 'Position']
    }
    populatePredefinedCols(predefCols)
        //------------IF THERE IS NO CONTENT---------------
    if (content) {
        LoadTable('.tableInpOut', selectedFIle, content)
    } else {
        let temp
        if (index == 0) { // -------------FIRST TABLE--------------
            temp = '<th scope="col">Name</th>'
            temp += '<th scope="col">Developmental Stage</th>'
            temp += '<th scope="col">Organism</th>'
            temp += '<th scope="col">Organism part</th>'
            temp += '<th scope="col">Material type</th>'

        } else
        if (index == 1) { // -------------SECOND TABLE--------------
            temp = '<th scope="col">Name</th>'
            temp += '<th scope="col">Applied Protocol</th>'
            temp += '<th scope="col">Material Type</th>'
            temp += '<th scope="col">Temperature</th>'
            temp += '<th scope="col">Unit</th>'
            temp += '<th scope="col">Bio Rep (BR)</th>'
            temp += '<th scope="col">Experimentalist</th>'
            temp += '<th scope="col">Output Label</th>'
        } else if (index == 2) { // -------------THIRD TABLE--------------
            temp = '<th scope="col">Input Label</th>'
            temp += '<th scope="col">Applied Protocol</th>'
            temp += '<th scope="col">Material Type</th>'
            temp += '<th scope="col">Output Label</th>'

        }
        $j('.tableInpOut thead').append('<tr>' + temp + '</tr>');
        AddRow('.tableInpOut')

    }

}

function populatePredefinedCols(colList) {
    $j('#preDefinedList li:not(:first-child)').remove()
    $j.each(colList, function(index) {
        $j('#preDefinedList').append(`<li><input type="button" class="btn btn-primary col-md-12 predef"  value="${colList[index]}"/></li>`);
    })

}

//SAVE CONTENT ON txt_file_content KEYUP
$j('#txt_file_content').keyup(function(event) {
    let content = $j(this).val().replace(/\n/g, '<br/>');
    setCookie(getCookie("selectedFIle"), content, 1000000)
})

function SaveTable(Table, saveName) {
    console.log($j(Table).prop('outerHTML'))
    setCookie(saveName, $j(Table).prop('outerHTML'), 1000000)
}

function LoadTable(Table, savedName, content) {
    $j(Table).html(content ? content : getCookie(savedName));
}