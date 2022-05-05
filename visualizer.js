const d3 = require('d3')
d3.selectAll("svg > *").remove();

const traceLength = 2
const offsetEachStateAddy = 205
const offsetEachStateAddx = 5
const stateSize = 200
const numberSquares = 2
const numberI = 7
const fontSize = "7px"

// 300x300
// currently 100x100, 3 columns and 3 rows
// print from 25, 25, 50, 25, 75, 25 (top row of outer square)
// inner square: 37.5, 37.5, 37.5, 50, 37.5, 62.5

// function convertRowColToCoordinates(square, i, yoffset) {
//     if (square == 0 && i == 0) {
//         return [37.5, yoffset + 37.5]
//     } else if (square == 0 && i == 1) {
//         return [50, yoffset + 37.5]
//     } else if (square == 0 && i == 2) {
//         return [65.5, yoffset + 37.5]
//     } else if (square == 0 && i == 3) {
//         return [65.5, yoffset + 50]
//     } else if (square == 0 && i == 4) {
//         return [65.5, yoffset + 69.5]
//     } else if (square == 0 && i == 5) {
//         return [50, yoffset + 69.5]
//     } else if (square == 0 && i == 6) {
//         return [37.5, yoffset + 69.5]
//     } else if (square == 0 && i == 7) {
//         return [37.5, yoffset + 50]
//     } else if (square == 1 && i == 0) {
//         return [22, yoffset + 25]
//     } else if (square == 1 && i == 1) {
//         return [50, yoffset + 25]
//     } else if (square == 1 && i == 2) {
//         return [79, yoffset + 25]
//     } else if (square == 1 && i == 3) {
//         return [79, yoffset + 50]
//     } else if (square == 1 && i == 4) {
//         return [79, yoffset + 75]
//     } else if (square == 1 && i == 5) {
//         return [50, yoffset + 75]
//     } else if (square == 1 && i == 6) {
//         return [22, yoffset + 75]
//     } else if (square == 1 && i == 7) {
//         return [22, yoffset + 50]
//     }
// }

function convertRowColToCoordinates(square, i, yoffset) {
    if (square == 0 && i == 0) {
        return [65, yoffset + 70]
    } else if (square == 0 && i == 1) {
        return [101, yoffset + 70]
    } else if (square == 0 && i == 2) {
        return [135, yoffset + 70]
    } else if (square == 0 && i == 3) {
        return [135, yoffset + 107]
    } else if (square == 0 && i == 4) {
        return [135, yoffset + 139]
    } else if (square == 0 && i == 5) {
        return [101, yoffset + 139]
    } else if (square == 0 && i == 6) {
        return [65, yoffset + 139]
    } else if (square == 0 && i == 7) {
        return [65, yoffset + 107]
    } else if (square == 1 && i == 0) {
        return [40, yoffset + 45]
    } else if (square == 1 && i == 1) {
        return [101, yoffset + 45]
    } else if (square == 1 && i == 2) {
        return [160, yoffset + 45]
    } else if (square == 1 && i == 3) {
        return [160, yoffset + 107]
    } else if (square == 1 && i == 4) {
        return [160, yoffset + 165]
    } else if (square == 1 && i == 5) {
        return [101, yoffset + 165]
    } else if (square == 1 && i == 6) {
        return [40, yoffset + 165]
    } else if (square == 1 && i == 7) {
        return [40, yoffset + 107]
    }
}

function printValue(square, i, yoffset, value) {
    const [xCoord, yCoord] = convertRowColToCoordinates(square, i, yoffset)
    if (value == 'P1') {
        d3.select(svg)
        .append("circle")
        .style("stroke", "gray")
        .style("fill", "black")
        .attr("r", 6)
        .attr("cx", xCoord+4)
        .attr("cy", yCoord-3);

        d3.select(svg)
        .append("text")
        .style("fill", "white")
        .style("font-size", fontSize)
        .attr("x", xCoord)
        .attr("y", yCoord)
        .text(value);
    }
    if (value == 'P2') {
        d3.select(svg)
        .append("circle")
        .style("stroke", "black")
        .style("fill", "white")
        .attr("r", 6)
        .attr("cx", xCoord+4)
        .attr("cy", yCoord-3);

        d3.select(svg)
        .append("text")
        .style("fill", "black")
        .style("font-size", fontSize)
        .attr("x", xCoord)
        .attr("y", yCoord)
        .text(value);
    }
}

function printState(stateAtom, yoffset) {
  d3.select(svg)
    .append('rect')
    .attr('x', offsetEachStateAddx)
    .attr('y', yoffset+1)
    .attr('width', stateSize)
    .attr('height', stateSize)
    .attr('stroke-width', 2)
    .attr('stroke', 'black')
    .attr('fill', 'transparent');
  d3.select(svg)
    .append('rect')
    .attr('x', offsetEachStateAddx+40)
    .attr('y', yoffset+1+40)
    .attr('width', stateSize-80)
    .attr('height', stateSize-80)
    .attr('stroke-width', 1)
    .attr('stroke', 'black')
    .attr('fill', 'transparent');
   d3.select(svg)
    .append('rect')
    .attr('x', offsetEachStateAddx+66)
    .attr('y', yoffset+1+66)
    .attr('width', stateSize-132)
    .attr('height', stateSize-132)
    .attr('stroke-width', 1)
    .attr('stroke', 'black')
    .attr('fill', 'transparent');
    // vertical lines
   d3.select(svg)
    .append("line")          // attach a line
    .style("stroke", "black")  // colour the line
    .attr("x1", 105)     // x position of the first end of the line
    .attr("y1", yoffset + 68)      // y position of the first end of the line
    .attr("x2", 105)     // x position of the second end of the line
    .attr("y2", yoffset + 40);
   d3.select(svg)
    .append("line")          // attach a line
    .style("stroke", "black")  // colour the line
    .attr("x1", 105)     // x position of the first end of the line
    .attr("y1", yoffset + 134)      // y position of the first end of the line
    .attr("x2", 105)     // x position of the second end of the line
    .attr("y2", yoffset + 162);
    // horizontal lines
    d3.select(svg)
    .append("line")          // attach a line
    .style("stroke", "black")  // colour the line
    .attr("x1", 138)     // x position of the first end of the line
    .attr("y1", yoffset + 105)      // y position of the first end of the line
    .attr("x2", 165)     // x position of the second end of the line
    .attr("y2", yoffset + 105);
   d3.select(svg)
    .append("line")          // attach a line
    .style("stroke", "black")  // colour the line
    .attr("x1", 44)     // x position of the first end of the line
    .attr("y1", yoffset + 105)      // y position of the first end of the line
    .attr("x2", 72)     // x position of the second end of the line
    .attr("y2", yoffset + 105);
   for (square = 0; square < numberSquares; square++) {
    for (i = 0; i <= numberI; i++) {
      printValue(square, i, yoffset, stateAtom.board[square][i].toString().substring(0,2))  
    }
  }
}

var offsetEachState = 0
for(b = 0; b < traceLength; b++) {  
  if(State.atom("State"+b) != null)
    printState(State.atom("State"+b), offsetEachState)  
  offsetEachState = offsetEachState + offsetEachStateAddy
}