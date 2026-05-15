import { apiFetch } from "@/lib/api/client";

export type HealthResponse = {
  status: string;
};

export function getHealth() {
  return apiFetch<HealthResponse>("/health");
}

