# Work To do Week2 - Applied Robotics

- The practice is uploaded in Atenea
- We have to finish the 1st Program (Developed during last class)
- Setup the locations of the Robotics (Home, One oven loc, unmoulding station, one conveyor)

## Practice Explaination

- There are 2 conveyors, placed between the 2 robots. Some chocolate chips have to dried inside a 3x3 oven. After being dried, the cookies moulds have to be place in a 1x1 unmoulding station.

- The conveyors have to be considered as accumulative conveyors, so the cookies can be accumulated there, but the unmoulding station only has capacity for 1 mould, so before taking a cookie from the oven, the unmoulding station has to be empty.

- For each point a security position is needed, the security positions must be placed above the positions.
  The number of positions has to be the minimum one, to be able to modify them without touching too many literals (see `offset` function (_page 507 of Manual RAPID.pdf_)).
