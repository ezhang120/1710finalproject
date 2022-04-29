const d3 = require('d3')
d3.selectAll("svg > *").remove();

const traceLength = 4
const offsetEachStateAddy = 105
const offsetEachStateAddx = 5
const stateSize = 100
const numberSquares = 2
const numberI = 7
const fontSize = "7px"

function convertRowColToCoordinates(square, i, yoffset) {
    if (square == 0 && i == 0) {
        return [37.5, yoffset + 37.5]
    } else if (square == 0 && i == 1) {
        return [50, yoffset + 37.5]
    } else if (square == 0 && i == 2) {
        return [62.5, yoffset + 37.5]
    } else if (square == 0 && i == 3) {
        return [62.5, yoffset + 50]
    } else if (square == 0 && i == 4) {
        return [62.5, yoffset + 62.5]
    } else if (square == 0 && i == 5) {
        return [50, yoffset + 62.5]
    } else if (square == 0 && i == 6) {
        return [37.5, yoffset + 62.5]
    } else if (square == 0 && i == 7) {
        return [37.5, yoffset + 50]
    } else if (square == 1 && i == 0) {
        return [25, yoffset + 25]
    } else if (square == 1 && i == 1) {
        return [50, yoffset + 25]
    } else if (square == 1 && i == 2) {
        return [75, yoffset + 25]
    } else if (square == 1 && i == 3) {
        return [75, yoffset + 50]
    } else if (square == 1 && i == 4) {
        return [75, yoffset + 75]
    } else if (square == 1 && i == 5) {
        return [50, yoffset + 75]
    } else if (square == 1 && i == 6) {
        return [25, yoffset + 75]
    } else if (square == 1 && i == 7) {
        return [25, yoffset + 50]
    }
}

function printValue(square, i, yoffset, value) {
    const [xCoord, yCoord] = convertRowColToCoordinates(square, i, yoffset)
  d3.select(svg)
    .append("text")
    .style("fill", "black")
    .style("font-size", fontSize)
    .attr("x", xCoord)
    .attr("y", yCoord)
    .text(value);
}

function printState(stateAtom, yoffset) {
  for (square = 0; square < numberSquares; square++) {
    for (i = 0; i <= numberI; i++) {
      printValue(square, i, yoffset, stateAtom.board[square][i].toString().substring(0,2))  
    }
  }
  
  d3.select(svg)
    .append('rect')
    .attr('x', offsetEachStateAddx)
    .attr('y', yoffset+1)
    .attr('width', stateSize)
    .attr('height', stateSize)
    .attr('stroke-width', 2)
    .attr('stroke', 'black')
    .attr('fill', 'transparent');
}

var offsetEachState = 0
for(b = 0; b < traceLength; b++) {  
  if(State.atom("State"+b) != null)
    printState(State.atom("State"+b), offsetEachState)  
  offsetEachState = offsetEachState + offsetEachStateAddy
}