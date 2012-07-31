package org.openmrs.module.cpm;

import org.openmrs.module.cpm.db.ConceptProposalDAO;
import org.springframework.transaction.annotation.Transactional;

@Transactional
public interface ConceptProposalService {

	public void setConceptProposalDAO(ConceptProposalDAO dao);

}
