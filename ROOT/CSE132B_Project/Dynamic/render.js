function greet() {
  alert("Hello, world!");
}

// different button function
function button_insert(){
  button = document.createElement('button');
  button.innerText = "insert";
  button.onclick = function(){insert(this)}; // wrap to avoid automatically run
  return button;
}

function button_update(){
  button = document.createElement('button');
  button.innerText = "update";
  button.onclick = function(){update(this)};
  return button;
}

function button_delete(){
  button = document.createElement('button');
  button.innerText = "delete";
  button.onclick = function(){delete_(this)};
  return button;
}

function button_detail(){
  button = document.createElement('button');
  button.innerText = "detail";
  button.onclick = function(){detail(this)};
  return button;
}
//create a a form with drop down menu displaying all students of current quarter with a details button
function add_form(table_name){
  if(table_name === "r1"){
    var table = document.createElement("table");
    table.setAttribute("table_name", "r1");
    var row = table.insertRow();
    var cell1 = row.insertCell();
    var cell2 = row.insertCell();
    //add heading
    var heading = document.createElement("h2");
    heading.textContent = "Get all classes a student is taking in current quarter:";
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(heading);
    //populate select
    var box1 = document.createElement("select");
    box1.setAttribute("r1_data","snn");
    var option1 = document.createElement("option");
    option1.text = "Select Student";
    box1.appendChild(option1);
    for(var i = 0; i < r1.length; i++){
      var option = document.createElement("option");
      option.text = r1[i] + r1_n[i]; // add name
      option.value = r1[i];
      box1.appendChild(option);
    }
    //append for cell1 and cell2 in table
    cell1.appendChild(box1);
    cell2.appendChild(button_detail());
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(table);
  } else if(table_name === 'r2'){
    var table = document.createElement("table");
    table.setAttribute("table_name", "r2");
    var row = table.insertRow();
    var cell1 = row.insertCell();
    var cell2 = row.insertCell();
    //add heading
    var heading = document.createElement("h2");
    heading.textContent = "Display Class Roster:";
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(heading);
    //populate select
    var box1 = document.createElement("select");
    box1.setAttribute("r2_data","class");
    var option1 = document.createElement("option");
    option1.text = "Select a Class";
    box1.appendChild(option1);
    for(var i = 0; i < r2.length; i++){
      var option = document.createElement("option");
      option.text = r2[i];
      option.value = r2[i].replace("Title:", "").replace("Quarter:", "").replace("Year:", "");
      box1.appendChild(option);
    }
    //append for cell1 and cell2 in table
    cell1.appendChild(box1);
    cell2.appendChild(button_detail());
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(table);
  }else if(table_name === 'r3'){
    var table = document.createElement("table");
    table.setAttribute("table_name", "r3");
    var row = table.insertRow();
    var cell1 = row.insertCell();
    var cell2 = row.insertCell();
    //add heading
    var heading = document.createElement("h2");
    heading.textContent = "Grade Report of a Student:";
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(heading);
    //populate select
    var box1 = document.createElement("select");
    box1.setAttribute("r3_data","snn");
    var option1 = document.createElement("option");
    option1.text = "Select Student";
    box1.appendChild(option1);
    for(var i = 0; i < r3.length; i++){
      var option = document.createElement("option");
      option.text = r3[i] + r3_n[i];
      option.value = r3[i];
      box1.appendChild(option);
    }
    //append for cell1 and cell2 in table
    cell1.appendChild(box1);
    cell2.appendChild(button_detail());
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(table);
  }else if(table_name === 'r4'){
    var table = document.createElement("table");
    table.setAttribute("table_name", "r4");
    var row = table.insertRow();
    var cell1 = row.insertCell();
    var cell2 = row.insertCell();
    var cell3 = row.insertCell();
    //add heading
    var heading = document.createElement("h2");
    heading.textContent = "Get Current degree requirements:";
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(heading);
    //populate select
    var box1 = document.createElement("select");
    box1.setAttribute("r4_data_1","snn");
    var option1 = document.createElement("option");
    option1.text = "Select an undergraduate student";
    box1.appendChild(option1);
    //create dropdown for undergrad student: snn
    for(var i = 0; i < r4.length; i++){
      var option = document.createElement("option");
      option.text = r4[i];
      option.value = r4[i];
      box1.appendChild(option);
    }
    //create dropdown for degrees
    var box2 = document.createElement("select");
    box2.setAttribute("r4_data_2","ucsd_degree");
    var option2 = document.createElement("option");
    option2.text = "Select a degree";
    box2.appendChild(option2);
    for(var i = 0; i < r4_d.length; i++){
      var option = document.createElement("option");
      option.text = r4_d[i];
      option.value = r4_d[i];
      box2.appendChild(option);
    }
    //append for cell1 and cell2 in table
    cell1.appendChild(box1);
    cell2.appendChild(box2);
    cell3.appendChild(button_detail());
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(table);
  }else if(table_name === 'r5'){
    var table = document.createElement("table");
    table.setAttribute("table_name", "r5");
    var row = table.insertRow();
    var cell1 = row.insertCell();
    var cell2 = row.insertCell();
    var cell3 = row.insertCell();
    //add heading
    var heading = document.createElement("h2");
    heading.textContent = "Get Current degree requirements:";
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(heading);
    //populate select
    var box1 = document.createElement("select");
    box1.setAttribute("r5_data_1","snn");
    var option1 = document.createElement("option");
    option1.text = "Select an graduate student";
    box1.appendChild(option1);
    //create dropdown for undergrad student: snn
    for(var i = 0; i < r5.length; i++){
      var option = document.createElement("option");
      option.text = r5[i] + r5_n[i];
      option.value = r5[i];
      box1.appendChild(option);
    }
    //create dropdown for degrees
    var box2 = document.createElement("select");
    box2.setAttribute("r5_data_2","ucsd_degree");
    var option2 = document.createElement("option");
    option2.text = "Select a degree";
    box2.appendChild(option2);
    for(var i = 0; i < r5_d.length; i++){
      var option = document.createElement("option");
      option.text = r5_d[i];
      option.value = r5_d[i];
      box2.appendChild(option);
    }
    //append for cell1 and cell2 in table
    cell1.appendChild(box1);
    cell2.appendChild(box2);
    cell3.appendChild(button_detail());
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(table);
  }else if(table_name === 'r8'){
    /*** form1 ***/
    var table = document.createElement("table");
    table.setAttribute("table_name", "r8");
    var row = table.insertRow();
    var cell1 = row.insertCell();
    var cell2 = row.insertCell();
    var cell3 = row.insertCell();
    var cell4 = row.insertCell();
    //add heading
    var heading = document.createElement("h2");
    heading.textContent = "Produce Stats:";
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(heading);
    //populate select
    var box1 = document.createElement("select");
    box1.setAttribute("r8_data_1","c_number");
    var option1 = document.createElement("option");
    option1.text = "Select a course";
    box1.appendChild(option1);
    //create dropdown for all courses
    for(var i = 2; i < course.length; i++){
      var option = document.createElement("option");
      option.text = course[i][0];
      option.value = course[i][0];
      box1.appendChild(option);
    }
    //create dropdown for faculty name
    var box2 = document.createElement("select");
    box2.setAttribute("r8_data_2","name");
    var option2 = document.createElement("option");
    option2.text = "Select a professor";
    box2.appendChild(option2);
    for(var i = 0; i < r8_d.length; i++){
      var option = document.createElement("option");
      option.text = r8_d[i];
      option.value = r8_d[i];
      box2.appendChild(option);
    }
    //create dropdown for qaurter
    var box3 = document.createElement("select");
    box3.setAttribute("r8_data_3","time");
    var option3 = document.createElement("option");
    option3.text = "Select a time";
    box3.appendChild(option3);
    for(var i = 0; i < r8.length; i++){
      var option = document.createElement("option");
      option.text = r8[i];
      option.value = r8[i];
      box3.appendChild(option);
    }
    //append for cell1 and cell2 in table
    cell1.appendChild(box1);
    cell2.appendChild(box2);
    cell3.appendChild(box3);
    cell4.appendChild(button_detail());
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(table);
  }else{
    var table = document.createElement("table");
    table.setAttribute("table_name", "r3rr03");
    var row = table.insertRow();
    var cell1 = row.insertCell();
    var cell2 = row.insertCell();
    //add heading
    var heading = document.createElement("h2");
    heading.textContent = "Get all classes a student is taking in current quarter:";
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(heading);
    //populate select
    var box1 = document.createElement("select");
    box1.setAttribute("r1_data","snn");
    var option1 = document.createElement("option");
    option1.text = "Select Student";
    box1.appendChild(option1);
    for(var i = 0; i < r1.length; i++){
      var option = document.createElement("option");
      option.text = r1[i];
      option.value = r1[i];
      box1.appendChild(option);
    }
    //append for cell1 and cell2 in table
    cell1.appendChild(box1);
    cell2.appendChild(button_detail());
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(table);
    console.log("error");
  }
  return table;
}



function data_entity(data, table_name) {
  var table = document.createElement("table");

  // Loop over the data array to add rows and cells to the table
  for (var i = 0; i < data.length; i++) {
    //prompt
    if (i == 0) {
      // var cell = table.insertRow();
      var heading = document.createElement("h2");
      switch (true) {
        case (typeof (student) !== "undefined" && data == student): heading.textContent = "Register a student:"; break;
        case (typeof (undergraduates) !== "undefined" && data == undergraduates): heading.textContent = "Register a student as an undergraduate:"; break;
        case (typeof (graduates) !== "undefined" && data == graduates): heading.textContent = "Register a student as a graduate:"; break;
        case (typeof (previous_d) !== "undefined" && data == previous_d): heading.textContent = "Register student's non-UCSD degree:"; break;
        case (typeof (attendance) !== "undefined" && data == attendance): heading.textContent = "Register a student's attendence:"; break;
        case (typeof (faculty) !== "undefined" && data == faculty): heading.textContent = "Register a faculty:"; break;
        case (typeof (course) !== "undefined" && data == course): heading.textContent = "Register a course:"; break;
        case (typeof (prerequirement) !== "undefined" && data == prerequirement): heading.textContent = "Log Pre-required Course:"; break;
        case (typeof (cat_belong) !== "undefined" && data == cat_belong): heading.textContent = "Log category:"; break;
        case (typeof (con_belong) !== "undefined" && data == con_belong): heading.textContent = "Log concentration:"; break;
        case (typeof (equivalent_num) !== "undefined" && data == equivalent_num): heading.textContent = "Log previous course number:"; break;
        case (typeof (classes) !== "undefined" && data == classes): heading.textContent = "Register a class:"; break;
        case (typeof (section) !== "undefined" && data == section): heading.textContent = "Register a section:"; break;
        case (typeof (teaching) !== "undefined" && data == teaching): heading.textContent = "Section is Taught by:"; break;
        case (typeof (weekly_meeting) !== "undefined" && data == weekly_meeting): heading.textContent = "register weekly meetings for section:"; break;
        case (typeof (enrollment) !== "undefined" && data == enrollment): heading.textContent = "Enroll a student into course:"; break;
        case (typeof (waitlist) !== "undefined" && data == waitlist): heading.textContent = "Waitlist a student into course:"; break;
        case (typeof (thesis_committee) !== "undefined" && data == thesis_committee): heading.textContent = "Register student's thesis Committee:"; break;
        case (typeof (advisory) !== "undefined" && data == advisory): heading.textContent = "Register student's advisory:"; break;
        case (typeof (probation) !== "undefined" && data == probation): heading.textContent = "Register Student Probation Period:"; break;
        case (typeof (review) !== "undefined" && data == review): heading.textContent = "Register section review:"; break;
        case (typeof (ucsd_degree) !== "undefined" && data == ucsd_degree): heading.textContent = "Register a UCSD Degree requirement:"; break;
        case (typeof (cat_requirement) !== "undefined" && data == cat_requirement): heading.textContent = "Register UCSD category requirement:"; break;
        case (typeof (con_requirement) !== "undefined" && data == con_requirement): heading.textContent = "Register UCSD concentration requirement:"; break;
        case (typeof (research) !== "undefined" && data == research): heading.textContent = "Register research:"; break;
        case (typeof (research_lead) !== "undefined" && data == research_lead): heading.textContent = "Register research lead:"; break;
        case (typeof (work_on_research) !== "undefined" && data == work_on_research): heading.textContent = "Register student to research:"; break;
      }
      mainContent = document.getElementById("mainContent");
      mainContent.appendChild(heading);
    }
    //if (i==1) // maybe i==1 just as new value......
    // ---> insert as an independent function...since still use it 
    //  continue;
    // i==1 still need, at least 1 row.
    var row = table.insertRow();
    for (var j = 0; j < data[i].length; j++) {
      var cell = row.insertCell();
      //cell.innerHTML = data[i][j];
      var box;
      if (i == 0) { // all just label
        cell.innerHTML = data[i][j];
      }
      else {
        if (data[1][j] === "varchar") {
          if(data[0][j] === "g_option" || data[0][j] === "option"){
            box = document.createElement('select');
            var option1 = document.createElement('option');
            option1.text = "Select Grade Option";
            var option2 = document.createElement('option');
            option2.value = "Letter";
            option2.text = "Letter";
            var option3 = document.createElement('option');
            option3.value = "S/U";
            option3.text = "S/U";
            var option4 = document.createElement('option');
            option4.value = "Letter or S/U";
            option4.text = "Letter or S/U";
            box.appendChild(option1);
            box.appendChild(option2);
            box.appendChild(option3);
            box.appendChild(option4);
            if (i > 1){
              box.value = data[i][j];
            }
          }else if (data[0][j] === "s_quarter" || data[0][j] === "e_quarter" || data[0][j] === "quarter" ){
            box = document.createElement('select');
            var option1 = document.createElement('option');
            option1.text = "Select Quarter Option";
            var option2 = document.createElement('option');
            option2.value = "Fall";
            option2.text = "Fall";
            var option3 = document.createElement('option');
            option3.value = "Winter";
            option3.text = "Winter";
            var option4 = document.createElement('option');
            option4.value = "Spring";
            option4.text = "Spring";
            var option5 = document.createElement('option');
            option5.value = "SummerI";
            option5.text = "SummerI";
            var option6 = document.createElement('option');
            option6.value = "SummerII";
            option6.text = "SummerII";
            box.appendChild(option1);
            box.appendChild(option2);
            box.appendChild(option3);
            box.appendChild(option4);
            box.appendChild(option5);
            box.appendChild(option6);
            if (i > 1){
              box.value = data[i][j];
            }
          }else if(data[0][j] === "level" || data[0][j] === "degree"){
            box = document.createElement('select');
            var option1 = document.createElement('option');
            option1.text = "Select Degree Option";
            var option2 = document.createElement('option');
            option2.value = "BS";
            option2.text = "BS";
            var option3 = document.createElement('option');
            option3.value = "MS/BS";
            option3.text = "MS/BS";
            var option4 = document.createElement('option');
            option4.value = "MS";
            option4.text = "MS";
            var option5 = document.createElement('option');
            option5.value = "PhD";
            option5.text = "PhD";
            box.appendChild(option1);
            box.appendChild(option2);
            box.appendChild(option3);
            box.appendChild(option4);
            box.appendChild(option5);
            if (i > 1){
              box.value = data[i][j];
            }
          }else if(data[0][j] === "ucsd_college"){
            box = document.createElement('select');
            var option1 = document.createElement('option');
            option1.text = "Select UCSD College Option";
            var option2 = document.createElement('option');
            option2.value = "Revelle";
            option2.text = "Revelle";
            var option3 = document.createElement('option');
            option3.value = "John Muir";
            option3.text = "John Muir";
            var option4 = document.createElement('option');
            option4.value = "Thurgood Marshall";
            option4.text = "Thurgood Marshall";
            var option5 = document.createElement('option');
            option5.value = "Earl Warren";
            option5.text = "Earl Warren";
            var option6 = document.createElement('option');
            option6.value = "Eleanor Roosevelt";
            option6.text = "Eleanor Roosevelt";
            var option7 = document.createElement('option');
            option7.value = "Sixth";
            option7.text = "Sixth";
            var option8 = document.createElement('option');
            option8.value = "Seventh";
            option8.text = "Seventh";
            box.appendChild(option1);
            box.appendChild(option2);
            box.appendChild(option3);
            box.appendChild(option4);
            box.appendChild(option5);
            box.appendChild(option6);
            box.appendChild(option7);
            box.appendChild(option8);
            if (i > 1){
              box.value = data[i][j];
            }
          }else if(data[0][j] === "m_day"){
            box = document.createElement('select');
            var option1 = document.createElement('option');
            option1.text = "Select Day";
            var option2 = document.createElement('option');
            option2.value = "M";
            option2.text = "M";
            var option3 = document.createElement('option');
            option3.value = "Tu";
            option3.text = "Tu";
            var option4 = document.createElement('option');
            option4.value = "W";
            option4.text = "W";
            var option5 = document.createElement('option');
            option5.value = "Th";
            option5.text = "Th";
            var option6 = document.createElement('option');
            option6.value = "F";
            option6.text = "F";
            var option7 = document.createElement('option');
            option7.value = "Sa";
            option7.text = "Sa";
            var option8 = document.createElement('option');
            option8.value = "Su";
            option8.text = "Su";
            box.appendChild(option1);
            box.appendChild(option2);
            box.appendChild(option3);
            box.appendChild(option4);
            box.appendChild(option5);
            box.appendChild(option6);
            box.appendChild(option7);
            box.appendChild(option8);
            if (i > 1){
              box.value = data[i][j];
            }
          }else if(data[0][j] === "m_type"){
            box = document.createElement('select');
            var option1 = document.createElement('option');
            option1.text = "Select Meeting Type";
            var option2 = document.createElement('option');
            option2.value = "LE";
            option2.text = "LE";
            var option3 = document.createElement('option');
            option3.value = "DI";
            option3.text = "DI";
            var option4 = document.createElement('option');
            option4.value = "LA";
            option4.text = "LA";
            var option5 = document.createElement('option');
            option5.value = "SE";
            option5.text = "SE";
            box.appendChild(option1);
            box.appendChild(option2);
            box.appendChild(option3);
            box.appendChild(option4);
            box.appendChild(option5);
            if (i > 1){
              box.value = data[i][j];
            }
          }else if(data[0][j] === "grade"){
            box = document.createElement('select');
            var option1 = document.createElement('option');
            option1.text = "Select Grade";
            var option2 = document.createElement('option');
            option2.value = "A PLUS";
            option2.text = "A+";
            var option3 = document.createElement('option');
            option3.value = "A";
            option3.text = "A";
            var option4 = document.createElement('option');
            option4.value = "A-";
            option4.text = "A-";
            var option5 = document.createElement('option');
            option5.value = "B PLUS";
            option5.text = "B+";
            var option6 = document.createElement('option');
            option6.value = "B";
            option6.text = "B";
            var option7 = document.createElement('option');
            option7.value = "B-";
            option7.text = "B-";
            var option8 = document.createElement('option');
            option8.value = "C PLUS";
            option8.text = "C+";
            var option9 = document.createElement('option');
            option9.value = "C";
            option9.text = "C";
            var option10 = document.createElement('option');
            option10.value = "C-";
            option10.text = "C-";
            var option11 = document.createElement('option');
            option11.value = "D";
            option11.text = "D";
            var option12 = document.createElement('option');
            option12.value = "S";
            option12.text = "S";
            var option13 = document.createElement('option');
            option13.value = "U";
            option13.text = "U";
            var option14 = document.createElement('option');
            option14.value = "IN";
            option14.text = "IN";
            box.appendChild(option1);
            box.appendChild(option2);
            box.appendChild(option3);
            box.appendChild(option4);
            box.appendChild(option5);
            box.appendChild(option6);
            box.appendChild(option7);
            box.appendChild(option8);
            box.appendChild(option9);
            box.appendChild(option10);
            box.appendChild(option11);
            box.appendChild(option12);
            box.appendChild(option13);
            box.appendChild(option14);
            if (i > 1){
              box.value = data[i][j];
            }
          }else{
            box = document.createElement('input');
            box.type = "text";
            if (i > 1)
              box.value = data[i][j];
          }
          // box = document.createElement('input');
          //   box.type = "text";
          //   if (i > 1)
          //     box.value = data[i][j];
        } else if (data[1][j] === "bool") {
          box = document.createElement('input');
          box.type = "checkbox";
          if (i > 1) {
            if (data[i][j] == "t")
              box.checked = true;
            else if (data[i][j] == "f")
              box.checked = false;
            else
              alert("unhandled value " + data[1][j] + "  " + data[i][j]);
          }
          // TODO: add serial
        } else if (data[1][j] === "int4" || data[1][j] === "float4" || data[1][j] === "serial") {
          box = document.createElement('input');
          box.type = "number";
          if (i > 1)
            box.value = data[i][j];
          if (data[1][j] === "serial")
            box.disabled = true;
        } else if (data[1][j] === "time") {
          box = document.createElement("input");
          box.type = "time";
          if (i > 1)
            box.value = data[i][j]
        } else if (data[1][j] === "date") {
          box = document.createElement("input");
          box.type = "date";
          if (i > 1)
            box.value = data[i][j];
        } else {
          alert("unhandled type  " + data[1][j]);
        }
        box.setAttribute("data_name", data[0][j]);
        box.setAttribute("data_type", data[1][j]);
        cell.appendChild(box);
      }
    }

    // action
    cell = row.insertCell();
    if (i == 0) {
      cell.innerHTML = "action";
    } else if (i == 1) {
      cell.appendChild(button_insert());
    } else {
      cell.appendChild(button_update());
      cell.appendChild(button_delete());
      cell.appendChild(button_detail());
    }
  }
  table.setAttribute("table_name", table_name);
  // Add the table to the page
  mainContent = document.getElementById("mainContent");
  mainContent.appendChild(table);
  return table;
}

function entity_insertrow(table){
  //table.insertBefore
   row = table.insertRow(1);
   row_pre = table.rows[2];
  row.outerHTML = row_pre.outerHTML; // already not include the value ???? 
  // change button
  button = document.createElement('button');
  button.innerText = "insert";
  row = table.rows[1]; // this makes more stable ????????????????
  cell = row.cells[row.cells.length-1];
  cell.innerHTML = ""; // can't just use innerHTML...otherwise onclick not add
  cell.appendChild(button);
  // add onclick event... button reuse below
  button.onclick = function(){insert(this)};

  // change the previous row's button
  cell_pre = row_pre.cells[row_pre.cells.length-1];
  cell_pre.innerHTML = "";
  cell_pre.appendChild(button_update());
  cell_pre.appendChild(button_delete());
  cell_pre.appendChild(button_detail());

  // table.innerHTML = table.innerHTML; // force to refresh
  return row;
  // refresh automatically, but need content

  // var row =  copy_row.cloneNode();//table.insertRow(1);

  /*for (var j = 0; j < copy_row.length; j++) {
      // just copy to avoid the discussion
      var cell = copy_row.tcell[j].cloneNode();
      row.insertCell().outerHTML = cell.outerHTML; // outer is entire, innerHTML only inside
  }*/
  // table.innerHTML = table.innerHTML; // force to refresh
  // return row;
  // refresh automatically, but need content
}

// delete the corresponding row
function entity_deletetrow(row){
  table = row.parentNode.parentNode;
  table.deleteRow(row.rowIndex);
}


function row_json(row, action){
  json ={};
  table = row.parentNode.parentNode;
  json["table_name"]=table.getAttribute("table_name");

  // row information
  cells = row.cells;
  for (i=0;i<cells.length-1;i++){
    box = cells[i].childNodes[0];
    data_type = box.getAttribute("data_type");
    data_name = box.getAttribute("data_name");
    value = null;
    if (data_type === "varchar") {
      value = box.value;
    } else if (data_type === "int4" || data_type === "serial") {
      value = box.value;
    } else if (data_type === "float4") {
      value = box.value;
    } else if (data_type === "date" || data_type === "real") {
      value = box.value;
    } else if (data_type === "bool") {
      if (box.checked) {
        value = "true";
      } else {
        value = "false";
      }
    } else if (data_type === "time") {
      var js_time = box.value;
      const [hours, minutes] = js_time.split(":");
      const newDate = new Date(2023,1,1,hours, minutes);
      var military_t = newDate.toLocaleTimeString('en-US',{hour12:false});
      value = military_t;
    } else {
      alert("unhandled data type to convert into sql " + data_type);
    }

    if (data_type === "serial" && action == "insert") {
      // ignore
    } else
      json[data_name] = value;
  }

  return json;
}

function restapi(json,func){ // fun
  xhr = new XMLHttpRequest();
  url = "FTMweb_action.jsp";
  xhr.open("POST", url, true);
  xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xhr.onreadystatechange = function() {
      if (xhr.readyState == 4 && xhr.status == 200) {
        console.log(xhr.responseText);
          json_response = JSON.parse(xhr.responseText);
          console.log(json_response);
          if(json_response["ifsuccess"]==="true"){
            alert(json["type"]+" succeed in "+json["table_name"]);
            func();
          } else if (json_response["ifsuccess"]==="false"){
            if (json_response.hasOwnProperty('sql_error')){
              alert(json_response["sql_error"]);
            } else
              alert("data error, not compatible with sql");
          } else {
            alert("unexpected ifsuccess = "+json_response["ifsuccess"]);
          }
      } else if (xhr.status == 500){
        alert("jsp error in server side"); 
      } else if (xhr.status == 200){
        // nothing 
      } else{
        alert("unhandled status " + xhr.status);
      }
  }

  params = "";
  keys = Object.keys(json);
  for(i=0;i<keys.length-1;i++)
    params += keys[i]+"="+json[keys[i]]+"&";
    params += keys[i]+"="+json[keys[i]];
  console.log("send\n"+params);
  xhr.send(params);

}

function insert(button){
  json = row_json(button.parentNode.parentNode, "insert");
  if (json == null){
    alert("data invalid");
    return;
  }
    

  // server side...send to insert into the database
  json["type"] = "insert";
  // client side(new row)..work only when successful

  table = button.parentNode.parentNode.parentNode.parentNode;
  restapi(json, entity_insertrow.bind(null, table));
}

function update(button){
  json = row_json(button.parentNode.parentNode,"update");
  if (json == null){
    alert("data invalid");
    return;
  }
    

  // server side...send to insert into the database
  json["type"] = "update";
  // client side(no extra action)..work only when successful

  table = button.parentNode.parentNode.parentNode.parentNode;
  restapi(json,function(){});
}

function delete_(button){
  json = row_json(button.parentNode.parentNode, "delete");
  if (json == null){
    alert("data invalid");
    return;
  }
    

  // server side...send to insert into the database
  json["type"] = "delete";
  // client side(n)..work only when successful

  row = button.parentNode.parentNode;
  restapi(json,entity_deletetrow.bind(null, row));
}

function detail(button) {
  // server side...send to update the database
  var url = "FTMweb_display.jsp?request=";
  var tName = button.closest('table').getAttribute('table_name');
  url += tName;
  //Get table name
  var cValues = button.closest('tr').getElementsByTagName("td");
  console.log(cValues);
  if(tName === 'r1' || tName === 'r2' || tName === 'r3'){
    for(var i =0; i < cValues.length - 1; i++){
      console.log(cValues[i].querySelector('select').getAttribute( tName+ '_data'));
      url+= '&'+cValues[i].querySelector('select').getAttribute( tName+ '_data');
      url+= "="+cValues[i].querySelector('select').value;
    }
  }else if(tName === 'r4' || tName === 'r5'){
    url+= '&'+cValues[0].querySelector('select').getAttribute( tName+ '_data_1');
    url+= '=' + cValues[0].querySelector('select').value;
    url+= '&' + cValues[1].querySelector('select').getAttribute( tName+ '_data_2');
    url+= '=' + cValues[1].querySelector('select').value;
  }if(tName === 'r8'){
    url+= '&'+cValues[0].querySelector('select').getAttribute( tName+ '_data_1');
    url+= '=' + cValues[0].querySelector('select').value;
    url+= '&' + cValues[1].querySelector('select').getAttribute( tName+ '_data_2');
    url+= '=' + cValues[1].querySelector('select').value;
    url+= '&' + cValues[2].querySelector('select').getAttribute( tName+ '_data_3');
    url+= '=' + cValues[2].querySelector('select').value;
  }
  window.open(url,"Display Data");
  // client side...add new row
  // entity_insertrow(table);
}

/*

table = data_entity(faculty,"faculty"); 
table = data_entity(student,"student"); 
table = data_entity(enrollment,"enrollment"); 
table = data_entity(section,"section"); 
table = data_entity(course,"course"); 
row = entity_insertrow(table);

add_form("r1");
*/




function data_select(data,table_name){
  if (table_name === "r2_a" || table_name === "r2_b"){
    var table = document.createElement("table");
    table.setAttribute("table_name", table_name);
    var row = table.insertRow();
    var cell1 = row.insertCell();
    var cell2 = row.insertCell();
    //add heading
    var heading = document.createElement("h2");
    if (table_name === "r2_a"){
      heading.textContent = "students currently enrolled";
    } else if (table_name === "r2_b") {
      heading.textContent = "section currently offered";
    }
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(heading);
    //populate select
    var box1 = document.createElement("select");
    // box1.setAttribute("r2_data","class");
    var option1 = document.createElement("option");
    if (table_name === "r2_a") {
      box1.setAttribute("value_type","social_security_num");
      option1.text = "Select a student";
    } else if(table_name === "r2_b") {
      box1.setAttribute("value_type","section_id");
      option1.text = "Select a section";
    }
    box1.appendChild(option1);
    for(var i = 2; i < data.length; i++){ // data begin from 2
      var option = document.createElement("option");
      if (table_name === "r2_a"){
        option.text = data[i][0] + " " +data[i][2] + " " + data[i][1]; // first_name-0, last_name-1, middle_name-2
        option.value = data[i][3]; // ssn-3
      } else if(table_name === "r2_b") {
        option.text = data[i][0];
        option.value = data[i][0];
      }
      
      box1.appendChild(option);
    }
    //append for cell1 and cell2 in table
    cell1.appendChild(box1);
    cell2.appendChild(button_detail_my());
    mainContent = document.getElementById("mainContent");
    mainContent.appendChild(table);
  }
}

function button_detail_my(){
  button = document.createElement('button');
  button.innerText = "detail";
  button.onclick = function(){detail_my(this)};
  return button;
}

function detail_my(button){
  // server side...send to update the database
  url = "FTMweb_query.jsp?table_name=";
  row = button.parentNode.parentNode;
  tName = row.parentNode.parentNode.getAttribute("table_name");
  url += tName;
  //get each query value
  cells = row.cells;
  for(i =0; i < cells.length - 1; i++){
    // console.log("&"+cells[i].childNodes[0].getAttribute("value_type")+"="+cells[i].childNodes[0].value);
    url +="&"+cells[i].childNodes[0].getAttribute("value_type")+"="+cells[i].childNodes[0].value;
  }
  window.open(url,"Display Data");
  // client side...add new row
  // entity_insertrow(table);
}

function disable_all (){
  // Get all elements on the page
  const elements = document.getElementsByTagName('*');

  // Disable each element
  for (let i = 0; i < elements.length; i++) {
    elements[i].disabled = true;
  }

  buttons = document.getElementsByTagName('button');

  // Disable each element
  for (let i = 0; i < buttons.length; i++) {
    buttons[i].hidden = true;
  }
}
