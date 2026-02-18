import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import { ProtectedRoute } from "./components/ProtectedRoute";
import { Login } from "./pages/auth/Login";
import { Signup } from "./pages/auth/Signup";
import { PatientDashboard } from "./pages/patient/Dashboard";
import { ProviderDashboard } from "./pages/provider/Dashboard";
import { AdminDashboard } from "./pages/admin/Dashboard";
import { Appointments } from "./pages/patient/Appointments";
import { Prescriptions } from "./pages/patient/Prescriptions";
import { Settings } from "./pages/patient/Settings";
import { Appointments as ProviderAppointments } from "./pages/provider/Appointments";
import { Prescriptions as ProviderPrescriptions } from "./pages/provider/Prescriptions";
import { Settings as ProviderSettings } from "./pages/provider/Settings";
import { Appointments as AdminAppointments } from "./pages/admin/Appointments";
import { Prescriptions as AdminPrescriptions } from "./pages/admin/Prescriptions";
import { Settings as AdminSettings } from "./pages/admin/Settings";

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          {/* Default redirect to login */}
          <Route path="/" element={<Navigate to="/login" />} />

          {/* Auth pages */}
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />

          {/* Patient pages */}
          <Route
            path="/patient"
            element={
              <ProtectedRoute role="patient">
                <PatientDashboard />
              </ProtectedRoute>
            }
          />

          {/* Provider pages */}
          <Route
            path="/provider"
            element={
              <ProtectedRoute role="provider">
                <ProviderDashboard />
              </ProtectedRoute>
            }
          />

          {/* Admin pages */}
          <Route
            path="/admin"
            element={
              <ProtectedRoute role="admin">
                <AdminDashboard />
              </ProtectedRoute>
            }
          />

          {/* Patient sub-pages */}
          <Route
            path="/patient/appointments"
            element={
              <ProtectedRoute role="patient">
                <Appointments />
              </ProtectedRoute>
            }
          />
          <Route
            path="/patient/prescriptions"
            element={
              <ProtectedRoute role="patient">
                <Prescriptions />
              </ProtectedRoute>
            }
          />
          <Route
            path="/patient/settings"
            element={
              <ProtectedRoute role="patient">
                <Settings />
              </ProtectedRoute>
            }
          />

          {/* Provider sub-pages */}
          <Route
            path="/provider/appointments"
            element={
              <ProtectedRoute role="provider">
                <ProviderAppointments />
              </ProtectedRoute>
            }
          />
          <Route
            path="/provider/prescriptions"
            element={
              <ProtectedRoute role="provider">
                <ProviderPrescriptions />
              </ProtectedRoute>
            }
          />
          <Route
            path="/provider/settings"
            element={
              <ProtectedRoute role="provider">
                <ProviderSettings />
              </ProtectedRoute>
            }
          />

          {/* Admin sub-pages */}
          <Route
            path="/admin/appointments"
            element={
              <ProtectedRoute role="admin">
                <AdminAppointments />
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/prescriptions"
            element={
              <ProtectedRoute role="admin">
                <AdminPrescriptions />
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/settings"
            element={
              <ProtectedRoute role="admin">
                <AdminSettings />
              </ProtectedRoute>
            }
          />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}
