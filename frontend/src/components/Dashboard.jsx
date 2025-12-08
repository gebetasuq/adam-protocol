import React from "react";

const rows = [
  {
    id: "CAMP-001",
    name: "Campus Alpha",
    reduction: "18.4%",
    blq: "12420"
  },
  {
    id: "CAMP-002",
    name: "District 3",
    reduction: "11.2%",
    blq: "8600"
  },
  {
    id: "CAMP-003",
    name: "Metro Hub",
    reduction: "22.9%",
    blq: "19875"
  }
];

export default function Dashboard() {
  return (
    <div className="dashboard">
      <table className="table">
        <thead>
          <tr>
            <th>Campus ID</th>
            <th>Name</th>
            <th>Energy Reduction</th>
            <th>BLq Minted</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => (
            <tr key={row.id}>
              <td>{row.id}</td>
              <td>{row.name}</td>
              <td>{row.reduction}</td>
              <td>{row.blq}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
