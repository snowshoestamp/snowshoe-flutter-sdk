import 'dart:math';

class Authentication {
  static const Point maxAnchor = Point(36, 36);
  static const Point minAnchor = Point(0, 0);

  static List<List<double>> getStampIdPoints(List<List<double>> stampPoints,
      int pointCount, double gridX, double gridY) {

    if(stampPoints.first.length != 2 || stampPoints.length < 3 || stampPoints.length != pointCount) {
      throw Exception("Wrong number of points");
    }

    int touchCount = stampPoints.length;
    Point maxAnchor = Point(gridX, gridY);
    Point minAnchor = const Point(0, 0);

    //1. Take the point count of X,Y coordinates of the stamp points into an array
    // =stampPoints
    //2. Make a matrix of distances between the stamp points. (this can be a one level array in program because when used it will just be counted through until highest number is reached)
    var distances = <double>[];
    for(int i = 0; i < stampPoints.length; i++) {
      for(int j = 0; j < stampPoints.length; j++) {
        if(i == j) {
          distances.add(0.0);
        }
        else {
          var point1 = stampPoints[i];
          var point2 = stampPoints[j];
          var distance = sqrt((point2[0]-point1[0])*(point2[0]-point1[0])+(point2[1]-point1[1])*(point2[1]-point1[1]));
          distances.add(distance);
        }
      }
    }

    //3. Find the first instance of the largest distance
    int position = 0;
    double largestDist = 0.0;
    for(int i = 0; i <= distances.length - stampPoints.length; i++){
      var currentDist = distances[i];
      if (currentDist > largestDist) {
        largestDist = currentDist;
        position = i;
      }
    }

    //4. Divide the number by 5 (and take the int from the answer) and modulo it by 5 to get the 2 anchor points in the array.
    var anchor1 = position ~/ touchCount;
    var anchor2 = position % touchCount;

    //5. Get the distance between the max and min x,y in the db.
    var minMaxDist = sqrt((maxAnchor.x-minAnchor.x)*(maxAnchor.x-minAnchor.x)+(maxAnchor.y-minAnchor.y)*(maxAnchor.y-minAnchor.y));

    //6. divide the [distance between the min/max anchor points] by the [distance between the input anchor points] to get the scaling factor.
    var scalingFactor = minMaxDist/largestDist;

    //7. get input anchor points center [(ap1 + ap2)/2] and min/max anchor points center.
    double centerX = (stampPoints[anchor1][0]+stampPoints[anchor2][0])/2;
    double centerY = (stampPoints[anchor1][1]+stampPoints[anchor2][1])/2;
    var anchorCenter = [centerX, centerY];
    var minMaxCenter = [(minAnchor.x+maxAnchor.x)/2, (minAnchor.y+maxAnchor.y)/2];

    //8. subtract the [input anchor points center] from the [min/max anchor points center] to get the anchor point difference.
    var anchorPointDif = [minMaxCenter[0] - anchorCenter[0], minMaxCenter[1] - anchorCenter[1]];

    //9. add the anchor point difference to all the stamp points so that the center of the distance between the input anchor points is the 0 point of the grid plus the center point of the min/max anchor point.
    var movedPoints = <List<double>>[];
    for(int i = 0; i < stampPoints.length; i++){
      var movedX = stampPoints[i][0] + anchorPointDif[0];
      var movedY = stampPoints[i][1] + anchorPointDif[1];
      movedPoints.add([movedX, movedY]);
    }

    //10. scale all the points (subtract the [min/max anchor point center] from point then multiply by scaling factor then add [min/max anchor point center] to it)
    var scaledPoints = <List<double>>[];
    for(int i = 0; i < movedPoints.length; i++){
      var scaledX = ((movedPoints[i][0]-minMaxCenter[0])*scalingFactor)+minMaxCenter[0];
      var scaledY = ((movedPoints[i][1]-minMaxCenter[1])*scalingFactor)+minMaxCenter[1];
      scaledPoints.add([scaledX, scaledY]);
    }

    //11. get the target point (max - min x,y) and target angle (arctan of target point y/x)
    var targetPoint = [maxAnchor.x - minAnchor.x, maxAnchor.y - minAnchor.y];
    var targetAngle = atan(targetPoint[1]/targetPoint[0]);

    //12. get current point (anchor1 - anchor0) and current angle (arctan of current point y/x)
    var currentPoint = [scaledPoints[anchor2][0] - scaledPoints[anchor1][0], scaledPoints[anchor2][1] - scaledPoints[anchor1][1]];
    var currentAngle = atan(currentPoint[1]/currentPoint[0]);

    //13. get rotation needed (target angle minus current angle)
    var rotation = targetAngle - currentAngle;

    //14. rotate points as needed, multiply [scaled points minus the [min/max anchor point center] (to center on grid for proper rotation) matrix] and the rotation matrix where theta is the rotation needed, then add [min/max anchor point center] back into that.
    //and
    //15. remove the two anchor points from the array of input and scaled stamp points.
    var rotatedPoints = <List<double>>[];
    for(int i = 0; i < scaledPoints.length; i++){
      //only rotate points if they are not anchor points.
      if (i != anchor1 && i != anchor2) {
        var scaledPoint = scaledPoints[i];
        var rotatedX = ((scaledPoint[0]-minMaxCenter[0])*cos(rotation) + (scaledPoint[1]-minMaxCenter[1])*(-sin(rotation)));
        var rotatedY = ((scaledPoint[0]-minMaxCenter[0])*sin(rotation) + (scaledPoint[1]-minMaxCenter[1])*cos(rotation));
        rotatedPoints.add([rotatedX + minMaxCenter[0], rotatedY + minMaxCenter[1]]);
      }
    }

    //16. find if there are more than one point below the diagonal. check if a point is below by getting the slope of the diagonal then the intercept [min y - slope[(maxY-minY)/(maxX-minX)] * min x] and subtracting the [x of a point times [slope plus intercept]] from the y of a point then checking if that number is greater than 0.
    var countBelowDiag = 0;
    var countAboveDiag = 0;
    var slope = (maxAnchor.y-minAnchor.y)/(maxAnchor.x-minAnchor.x);
    var intercept = minAnchor.y - slope * minAnchor.x;
    for(int i = 0; i < rotatedPoints.length; i++){
      var distBelowDiag = rotatedPoints[i][1] - (rotatedPoints[i][0] * slope + intercept);
      if (slope.isInfinite) {
        distBelowDiag = minAnchor.x - rotatedPoints[i][0];
      }
      if (distBelowDiag > 0) {
        countBelowDiag += 1;
      }
      else {
        countAboveDiag += 1;
      }
    }

    //17. if there are more than one point below the diagonal rotate 180 degrees (pi).
    if (countBelowDiag > countAboveDiag) {
      var tempRotatedPoints = rotatedPoints;
      rotatedPoints = <List<double>>[];
      for(int i = 0; i < tempRotatedPoints.length; i++) {
        var tempRotatedPoint = tempRotatedPoints[i];
        var rotatedX = ((tempRotatedPoint[0]-minMaxCenter[0])*cos(pi) + (tempRotatedPoint[1]-minMaxCenter[1])*(-sin(pi)));
        var rotatedY = ((tempRotatedPoint[0]-minMaxCenter[0])*sin(pi) + (tempRotatedPoint[1]-minMaxCenter[1])*cos(pi));
        rotatedPoints.add([rotatedX + minMaxCenter[0], rotatedY + minMaxCenter[1]]);
      }
    }

    //18. sort the points by distance from the diagonal (find this using the way described above) from low to high.
    var sortedPoints = sortPoints(rotatedPoints, gridX, gridY);

    return sortedPoints;
  }

  static List<List<double>> sortPoints(List<List<double>> stampPoints, double gridX, double gridY) {
    var slope = (maxAnchor.y-minAnchor.y)/(maxAnchor.x-minAnchor.x);
    var intercept = minAnchor.y - slope * minAnchor.x;

    //sort the points by distance from the diagonal (find this using the way described above) from low to high.
    stampPoints.sort((point1, point2) => _diagonalComparator(point1, point2, slope, intercept));

    return stampPoints;
  }

  static int _diagonalComparator(List<double> point1, List<double> point2, double slope, double intercept){
    var distBelowDiag = point1[1] - (point1[0] * slope + intercept);
    var distBelowDiag2 = point2[1] - (point2[0] * slope + intercept);
    if (distBelowDiag < distBelowDiag2) return 1;
    if (distBelowDiag == distBelowDiag2) return 0;
    return -1;
  }
}