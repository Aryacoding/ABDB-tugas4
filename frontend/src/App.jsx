// File: src/App.jsx
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Pelanggan from './pages/Pelanggan';
import WorkOrder from './pages/WorkOrder';
import Laporan from './pages/Laporan';
import Motor from './pages/Motor';
import Pembayaran from './pages/Pembayaran';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/pelanggan" element={<Pelanggan />} /> 
        <Route path="/work-order" element={<WorkOrder />} /> 
        <Route path="/laporan" element={<Laporan />} />
        <Route path="/motor" element={<Motor />} />
        <Route path="/pembayaran" element={<Pembayaran />} />
        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </Router>
  );
}

export default App;