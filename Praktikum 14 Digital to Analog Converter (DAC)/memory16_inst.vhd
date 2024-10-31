memory16_inst : memory16 PORT MAP (
		data	 => data_sig,
		wren	 => wren_sig,
		address	 => address_sig,
		clock	 => clock_sig,
		q	 => q_sig
	);
