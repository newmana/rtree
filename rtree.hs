-- Based on http://neonstorm242.blogspot.com.au/2011/02/spatial-range-queries-using-r-trees.html

import Data.List
import Data.Ord

type Point = (Float,Float)
type BoundingBox = (Point,Point)
data Shape = Polyline [Point] BoundingBox | Polygon [Point] BoundingBox | Pointtype Point deriving (Show)
data RNode = Inner BoundingBox [RNode] | Leaf BoundingBox [Shape] deriving (Show)

shapeBb (Polyline _ bb) = bb
shapeBb (Polygon _ bb) = bb
shapeBb (Pointtype p) = (p,p)

nodeBb (Inner bb _) = bb
nodeBb (Leaf bb _) = bb

calculateBoundingBox :: [Point] -> BoundingBox
calculateBoundingBox points =
  let 
    (x0, _) = minimumBy (comparing (\(x0,_) -> x0)) points
    (_, y0) = minimumBy (comparing (\(_,y0) -> y0)) points
    (x1, _) = maximumBy (comparing (\(x1,_) -> x1)) points
    (_, y1) = maximumBy (comparing (\(_,y1) -> y1)) points
  in ((x0,y0),(x1,y1))
  
   
testBoundingBoxOverlap :: BoundingBox -> BoundingBox -> Bool
testBoundingBoxOverlap ((x0,y0),(x1,y1)) ((x2,y2),(x3,y3))
   | abs ((x1+x0)/2 - (x3+x2)/2) > half_w0 + half_w1 = False
   | abs ((y1+y0)/2 - (y3+y2)/2) > half_h0 + half_h1 = False
   | otherwise = True
   where
       ((half_w0,half_h0),(half_w1,half_h1)) = (((x1-x0)/2,(y1-y0)/2) , ((x3-x2)/2,(y3-y2)/2))
   
totalBoundingBox :: [BoundingBox] -> BoundingBox
totalBoundingBox bbs = 
   let
       ((x0,_),(_)) = minimumBy (comparing (\(((x0,_),(_))) -> x0)) bbs
       ((_,y0),(_)) = minimumBy (comparing (\(((_,y0),(_))) -> y0)) bbs
       ((_),(x1,_)) = maximumBy (comparing (\(((_),(x1,_))) -> x1)) bbs
       ((_),(_,y1)) = maximumBy (comparing (\(((_),(_,y1))) -> y1)) bbs
   in ((x0,y0),(x1,y1)) 

splitList :: Int -> [a] -> [[a]]
splitList n xs
   | length xs <= n = [xs]
   | otherwise = [take n xs] ++ splitList n (drop n xs)
 
 
buildInnerNodes :: Int -> [RNode] -> [RNode]
buildInnerNodes m nodes
   | length nodes == 1 = nodes
   | otherwise = buildInnerNodes m $ map (\innerNodes -> (Inner (nodesBoundingBox innerNodes) innerNodes)) (splitList m nodes)
   where 
      nodesBoundingBox nodes = totalBoundingBox $ map (\n -> nodeBb n) nodes   
       
buildPackedRTree :: Int -> [Shape] -> RNode
buildPackedRTree m shapes = head $ buildInnerNodes m $ map (\shapes -> (Leaf (shapesBoundingBox shapes) shapes)) splittedShapeList
   where 
      splittedShapeList = splitList m $ sortedShapes shapes
      shapesBoundingBox shapes = totalBoundingBox $ map (\s -> shapeBb s) shapes

sortedShapes :: [Shape] -> [Shape]
sortedShapes shapes = sortBy (comparing (\s -> let (lowerLeft,_) = shapeBb s in lowerLeft)) shapes

searchNodes :: RNode -> BoundingBox -> [RNode]
searchNodes (Leaf nodeBb shapes) bb = if testBoundingBoxOverlap nodeBb bb then [(Leaf nodeBb shapes)] else []
searchNodes (Inner _ entries) bb = concatMap (\n -> searchNodes n bb) (filteredrNodes)
   where
      filteredrNodes = filter (\n -> testBoundingBoxOverlap (nodeBb n) bb) entries
 
queryRTree :: RNode -> BoundingBox -> [Shape]
queryRTree root bb = filter (\n -> testBoundingBoxOverlap (shapeBb n) bb) allShapes
   where 
      filteredLeafs = searchNodes root bb
      allShapes = concatMap (\(Leaf _ shapes) -> shapes) filteredLeafs

p1 = (1.0, 1.0)
p2 = (2.0, 2.0)
p3 = (1.0, 3.0)
s1 = Pointtype p1
s2 = Pointtype p2
s3 = Pointtype p3
s4 = Polyline [(1.0, 1.5), (1.5, 1.5)] ((1.0,1.5),(1.5, 1.5))
rtree = buildPackedRTree 3 [s1, s2, s3, s4]
