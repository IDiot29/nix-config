// @ts-nocheck -- Pi provides its extension types at runtime.
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const STATE_TYPE = "yolo-state";

export default function (pi: ExtensionAPI) {
	let enabled = false;
	let active = true;
	let disposeAuthorizer;

	pi.on("session_start", (_event, ctx) => {
		enabled = false;
		for (const entry of ctx.sessionManager.getBranch()) {
			if (
				entry.type === "custom" &&
				entry.customType === STATE_TYPE &&
				typeof entry.data?.enabled === "boolean"
			) {
				enabled = entry.data.enabled;
			}
		}
	});

	const unsubscribeReady = pi.events.on("permissions:ready", () => {
		void (async () => {
			try {
				const { getPermissionsService } = await import(
					"@gotgenes/pi-permission-system"
				);
				const permissions = getPermissionsService();
				if (!active || !permissions) return;
				disposeAuthorizer?.();
				disposeAuthorizer = permissions.registerAuthorizer("yolo", async () =>
					enabled ? { kind: "allow" } : { kind: "defer" },
				);
			} catch {
				// Permission system is optional outside the configured Pi setup.
			}
		})();
	});

	pi.on("session_shutdown", () => {
		active = false;
		unsubscribeReady();
		disposeAuthorizer?.();
	});

	pi.registerCommand("yolo", {
		description: "Toggle automatic approval while preserving hard denials",
		handler: async (args, ctx) => {
			const requested = args.trim().toLowerCase();
			if (requested && requested !== "on" && requested !== "off") {
				ctx.ui.notify("Usage: /yolo [on|off]", "warning");
				return;
			}

			enabled = requested ? requested === "on" : !enabled;
			pi.appendEntry(STATE_TYPE, { enabled });
			ctx.ui.notify(
				`YOLO mode ${enabled ? "on" : "off"}. Hard denials still apply.`,
				enabled ? "warning" : "info",
			);
		},
	});
}
